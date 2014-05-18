/*********************************************************
  Copyright (C), 2013-2016
  File name: utils.em
  Author: 	txl
  Version: 1.0
  Date: 13.11.23
  Description:
  History:
*********************************************************/

/*************************************************
  Function: 	strstr
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro strstr(str1,str2)
{
    i = 0
    j = 0
    len1 = strlen(str1)
    len2 = strlen(str2)
    if((len1 == 0) || (len2 == 0))
    {
        return 0xffffffff
    }
    while( i < len1)
    {
        if(str1[i] == str2[j])
        {
            while(j < len2)
            {
                j = j + 1
                if(str1[i+j] != str2[j]) 
                {
                    break
                }
            }     
            if(j == len2)
            {
                return i
            }
            j = 0
        }
        i = i + 1      
    }  
    return 0xffffffff
}

/*************************************************
  Function: GetCommentsPos
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro GetCommentsPos()
{
     var funPos
     var fun
     fun = GetCurSymbol()
     funPos = GetSymbolLine(fun)
     return funPos
}

/*************************************************
  Function: 	GetFileNameNoExt
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro GetFileNameNoExt(sz)
{
    i = 1
    szName = sz
    iLen = strlen(sz)
    j = iLen 
    if(iLen == 0)
      return ""
    while( i <= iLen)
    {
      if(sz[iLen-i] == ".")
      {
         j = iLen-i 
      }
      if( sz[iLen-i] == "\\" )
      {
         szName = strmid(sz,iLen-i+1,j)
         return szName
      }
      i = i + 1
    }
    szName = strmid(sz,0,j)
    return szName
}

/*************************************************
  Function: 	GetFileName
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro GetFileName(sz)
{
    i = 1
    szName = sz
    iLen = strlen(sz)
    if(iLen == 0)
      return ""
    while( i <= iLen)
    {
      if(sz[iLen-i] == "\\")
      {
        szName = strmid(sz,iLen-i+1,iLen)
        break
      }
      i = i + 1
    }
    return szName
}

/*************************************************
  Function: GetFunDescribe
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro GetFunDescribe()
{
    str = Ask ("Please Input Function Describe !")
    return str
}

/*************************************************
  Function: 	GetAuthor
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro GetAuthor()
{
	myname = getreg(MYNAME)
    return myname
}

/*************************************************
  Function: 	GetLauguage
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro GetLauguage()
{
	language = getreg(LANGUAGE)
    return language
}

/*************************************************
  Function: CloseFileWindows
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro CloseFileWindows()
{
    cwnd = WndListCount()
    iwnd = 0
    while (1)
    {
        hwnd = WndListItem(0)
        hbuf = GetWndBuf(hwnd)
        SaveBuf(hbuf)
        CloseWnd(hwnd)
        iwnd = iwnd + 1
        if(iwnd >= cwnd)
        {
            break
        }
    }
}

/*************************************************
  Function: 	CreateBlankString
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro CreateBlankString(nBlankCount)
{
    szBlank=""
    nIdx = 0
    while(nIdx < nBlankCount)
    {
        szBlank = cat(szBlank," ")
        nIdx = nIdx + 1
    }
    return szBlank
}

/*************************************************
  Function: 	GetWordFromString
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro GetWordFromString(hbuf,szLine,nBeg,nEnd,chBeg,chSeparator,chEnd)
{
    if((nEnd > strlen(szLine) || (nBeg > nEnd))
    {
        return 0
    }
    nMaxLen = 0
    nIdx = nBeg
    while(nIdx < nEnd)
    {
        if(szLine[nIdx] == chBeg)
        {
            break
        }
        nIdx = nIdx + 1
    }
    nBegWord = nIdx + 1
    
    iCount = 0
    
    nEndWord = 0
    while(nIdx < nEnd)
    {
        if(szLine[nIdx] == chSeparator)
        {
           szWord = strmid(szLine,nBegWord,nIdx)
           szWord = TrimString(szWord)
           nLen = strlen(szWord)
           if(nMaxLen < nLen)
           {
               nMaxLen = nLen
           }
           AppendBufLine(hbuf,szWord)
           nBegWord = nIdx + 1
        }
        if(szLine[nIdx] == chBeg)
        {
            iCount = iCount + 1
        }
        if(szLine[nIdx] == chEnd)
        {
            iCount = iCount - 1
            nEndWord = nIdx
            if( iCount == 0 )
            {
                break
            }
        }
        nIdx = nIdx + 1
    }
    if(nEndWord > nBegWord)
    {
        szWord = strmid(szLine,nBegWord,nEndWord)
        szWord = TrimString(szWord)
        nLen = strlen(szWord)
        if(nMaxLen < nLen)
        {
            nMaxLen = nLen
        }
        AppendBufLine(hbuf,szWord)
    }
    return nMaxLen
}

/*************************************************
  Function: IfdefSz
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro IfdefSz(sz)
{
    ProgEnvInfo = GetProgramEnvironmentInfo ()
    Editor = GetAuthorbySelf()
 
    hwnd = GetCurrentWnd()
    lnFirst = GetWndSelLnFirst(hwnd)
    lnLast = GetWndSelLnLast(hwnd)
    LocalTime = GetSysTime(1)
 
    Year = LocalTime.Year
    Month = LocalTime.Month
    Day = LocalTime.Day
    Time = LocalTime.time
    hbuf = GetCurrentBuf()
    InsBufLine(hbuf, lnFirst, "#ifdef @sz@ /* Edit By @Editor@ @Year@-@Month@-@Day@ */")
    InsBufLine(hbuf, lnLast+2, "#endif ")
}

/*************************************************
  Function: IfdefSz
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro IfndefSz(sz)
{
    ProgEnvInfo = GetProgramEnvironmentInfo ()
    Editor = GetAuthorbySelf()
 
    hwnd = GetCurrentWnd()
    lnFirst = GetWndSelLnFirst(hwnd)
    lnLast = GetWndSelLnLast(hwnd)
    LocalTime = GetSysTime(1)
 
    Year = LocalTime.Year
    Month = LocalTime.Month
    Day = LocalTime.Day
    Time = LocalTime.time
    hbuf = GetCurrentBuf()
    InsBufLine(hbuf, lnFirst, "#ifndef @sz@ /* Edit By @Editor@ @Year@-@Month@-@Day@ */")
    InsBufLine(hbuf, lnLast+2, "#endif ")
}

/*************************************************
  Function: CommentSz
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro CommentSz(sz)
{
 	ProgEnvInfo = GetProgramEnvironmentInfo ()
    Editor = GetAuthorbySelf()
 
    LocalTime = GetSysTime(1)
 
    Year = LocalTime.Year
    Month = LocalTime.Month
    Day = LocalTime.Day
    Time = LocalTime.time
 	hbufCur = GetCurrentBuf();
 	SetBufSelText (hbufCur, "/* Comment: @sz@ Edit By @Editor@ @Year@-@Month@-@Day@ */")
}

/*************************************************
  Function: 	CreateCPP
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro CreateCPP(hbuf,line)
{
	ln = line
    InsBufLine(hbuf,ln++,"#ifdef __cplusplus")
    InsBufLine(hbuf,ln++,"#if __cplusplus")
    InsBufLine(hbuf,ln++,"extern \"C\" {")
    InsBufLine(hbuf,ln++,"#endif")
    InsBufLine(hbuf,ln++,"#endif")
    InsBufLine(hbuf,ln++,"")
    InsBufLine(hbuf,ln++,"")
    InsBufLine(hbuf,ln++,"")
	InsBufLine(hbuf,ln++,"#ifdef __cplusplus")
	InsBufLine(hbuf,ln++,"#if __cplusplus")
    InsBufLine(hbuf,ln++,"}")
    InsBufLine(hbuf,ln++,"#endif")
    InsBufLine(hbuf,ln++,"#endif")    
    return ln;
}

/*************************************************
  Function: 	FileHeaderEN
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro FileHeaderEN(hbuf, ln, FileName, Author)
{
	lnFirst = ln
	LocalTime = GetSysTime(1)
    Year = LocalTime.Year+3
    YearLast = LocalTime.Year-3
    Month = LocalTime.Month
    Day = LocalTime.Day
    
	InsBufLine(hbuf, lnFirst++, "/*********************************************************")
    InsBufLine(hbuf, lnFirst++, " Copyright (C),@YearLast@-@Year@,Electronic Technology Co.,Ltd.")
    InsBufLine(hbuf, lnFirst++, " File name: 		@FileName@")
    InsBufLine(hbuf, lnFirst++, " Author: 			@Author@")
    InsBufLine(hbuf, lnFirst++, " Version: 			1.0")
    InsBufLine(hbuf, lnFirst++, " Date: 				@Year@-@Month@-@Day@")
    InsBufLine(hbuf, lnFirst++, " Description: 		")
    InsBufLine(hbuf, lnFirst++, " History: 			")
    InsBufLine(hbuf, lnFirst++, " 					")
    InsBufLine(hbuf, lnFirst++, "   1.Date:	 		@Year@-@Month@-@Day@")
    InsBufLine(hbuf, lnFirst++, " 	 Author:	 	@Author@")
    InsBufLine(hbuf, lnFirst++, " 	 Modification:  Created file")   
 	InsBufLine(hbuf, lnFirst++, "   2. ... ")
    InsBufLine(hbuf, lnFirst++, "*********************************************************/")
    SetBufIns (hbuf, lnFirst,0)
}

/*************************************************
  Function: 	FileHeaderCN
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro FileHeaderCN(hbuf, ln, FileName, Author)
{
	lnFirst = ln
	LocalTime = GetSysTime(1)
    Year = LocalTime.Year+3
    YearLast = LocalTime.Year-3
    Month = LocalTime.Month
    Day = LocalTime.Day
    
	InsBufLine(hbuf, lnFirst++, "/*********************************************************")
    InsBufLine(hbuf, lnFirst++, " 版权所有 (C),@YearLast@-@Year@ ")
    InsBufLine(hbuf, lnFirst++, " 文 件 名: 			@FileName@")
    InsBufLine(hbuf, lnFirst++, " 作    者: 			@Author@")
    InsBufLine(hbuf, lnFirst++, " 版 本 号: 			1.0")
    InsBufLine(hbuf, lnFirst++, " 生成日期: 			@Year@-@Month@-@Day@")
    InsBufLine(hbuf, lnFirst++, " 功能描述: 			")
    InsBufLine(hbuf, lnFirst++, " 修改历史: 			")
    InsBufLine(hbuf, lnFirst++, " 					")
    InsBufLine(hbuf, lnFirst++, "   1.日    期:	 	@Year@-@Month@-@Day@")
    InsBufLine(hbuf, lnFirst++, " 	 作    者:	 	@Author@")
    InsBufLine(hbuf, lnFirst++, " 	 修改内容:  	创建文件")   
 	InsBufLine(hbuf, lnFirst++, "   2. ... ")
    InsBufLine(hbuf, lnFirst++, "*********************************************************/")
    SetBufIns (hbuf, lnFirst,0)
}

/*************************************************
  Function: 	HistoryContentEN
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro HistoryContentEN(hbuf,ln,Author)
{
    SysTime = GetSysTime(1);
    szTime = SysTime.Date
    Year = SysTime.Year
    Month = SysTime.month
    Day = SysTime.day

    InsBufLine(hbuf, ln++, "   1.Date:	 		@Year@-@Month@-@Day@")
    InsBufLine(hbuf, ln++, " 	 Author:	 	@Author@")
    szContent = Ask("Please input modification")
    InsBufLine(hbuf, ln++, " 	 Modification:  @szContent@")   
}

/*************************************************
  Function: 	GetFunctionDef
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro GetFunctionDef(hbuf,symbol)
{
    ln = symbol.lnName
    szFunc = ""
    if(strlen(symbol) == 0)
    {
       return szFunc
    }
    fIsEnd = 1
    while(ln < symbol.lnLim)
    {
        szLine = GetBufLine (hbuf, ln)
        RetVal = SkipCommentFromString(szLine,fIsEnd)
		szLine = RetVal.szContent
		szLine = TrimString(szLine)
		fIsEnd = RetVal.fIsEnd
        ret = strstr(szLine,"{")        
        if(ret != 0xffffffff)
        {
            szLine = strmid(szLine,0,ret)
            szFunc = cat(szFunc,szLine)
            break
        }
        szFunc = cat(szFunc,szLine)        
        ln = ln + 1
    }
    return szFunc
}

/*************************************************
  Function: 	FuncHeadCommentCN
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro FuncHeadCommentCN(hbuf, ln, szFunc)
{
    iIns = 0
	symbol = GetSymbolLocationFromLn(hbuf, ln)
    if(strlen(symbol) > 0)
    {
        hTmpBuf = NewBuf("Tempbuf")
            
        szLine = GetFunctionDef(hbuf,symbol)            
        iBegin = symbol.ichName
        
        szTemp = strmid(szLine,0,iBegin)
        szTemp = TrimString(szTemp)
        szRet =  GetFirstWord(szTemp)
        if(symbol.Type == "Method")
        {
            szTemp = strmid(szTemp,strlen(szRet),strlen(szTemp))
            szTemp = TrimString(szTemp)
            if(szTemp == "::")
            {
                szRet = ""
            }
        }
        if(toupper (szRet) == "MACRO")
        {
            szRet = ""
        }

        nMaxParamSize = GetWordFromString(hTmpBuf,szLine,iBegin,strlen(szLine),"(",",",")")
        lnMax = GetBufLineCount(hTmpBuf)
        ln = symbol.lnFirst
        SetBufIns (hbuf, ln, 0)
    }

	InsBufLine(hbuf, ln++, "/*************************************************")
    InsBufLine(hbuf, ln++, " 函 数 名:		@szFunc@")
    des = GetFunDescribe()
    InsBufLine(hbuf, ln++, " 描    述: 		@des@")
    i = 0
    while ( i < lnMax) 
    {
        szTmp = GetBufLine(hTmpBuf, i)
        nLen = strlen(szTmp);
		if(szTmp == "void")
        {
        	break
        }
        InsBufLine(hbuf, ln++, " 输入参数: ")
		param = ""
		j = 0;
		k = 0;
		while(j < nlen)
		{
			if(k == 0)
			{
				if(szTmp[j] == " ")
				{
					k = 1
				}
			}
			else
			{
				param = Cat(param, szTmp[j])
			}
			j = j+1
		}
        i = i + 1
        InsBufLine(hbuf, ln++, "	@i@.@param@")
        iIns = 1
    }    
    closebuf(hTmpBuf)
    if(iIns == 0)
    {       
        InsBufLine(hbuf, ln++, " 输入参数: 		无")
    }
	InsBufLine(hbuf, ln++, " 输出参数: 	")
 	InsBufLine(hbuf, ln++, " 返 回 值: 	")
 	InsBufLine(hbuf, ln++, " 其    他:  	")
    InsBufLine(hbuf, ln++, "*************************************************/")
}

/*************************************************
  Function: 	FuncHeadCommentEN
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro FuncHeadCommentEN(hbuf, ln, szFunc)
{
    iIns = 0
	symbol = GetSymbolLocationFromLn(hbuf, ln)
    if(strlen(symbol) > 0)
    {
        hTmpBuf = NewBuf("Tempbuf")
            
        szLine = GetFunctionDef(hbuf,symbol)            
        iBegin = symbol.ichName
        
        szTemp = strmid(szLine,0,iBegin)
        szTemp = TrimString(szTemp)
        szRet =  GetFirstWord(szTemp)
        if(symbol.Type == "Method")
        {
            szTemp = strmid(szTemp,strlen(szRet),strlen(szTemp))
            szTemp = TrimString(szTemp)
            if(szTemp == "::")
            {
                szRet = ""
            }
        }
        if(toupper (szRet) == "MACRO")
        {
            szRet = ""
        }

        nMaxParamSize = GetWordFromString(hTmpBuf,szLine,iBegin,strlen(szLine),"(",",",")")
        lnMax = GetBufLineCount(hTmpBuf)
        ln = symbol.lnFirst
        SetBufIns (hbuf, ln, 0)
    }

	InsBufLine(hbuf, ln++, "/*************************************************")
    InsBufLine(hbuf, ln++, " Function:		@szFunc@")
    des = GetFunDescribe()
    InsBufLine(hbuf, ln++, " Descroption:	@des@")
    i = 0
    while ( i < lnMax) 
    {
        szTmp = GetBufLine(hTmpBuf, i)
        nLen = strlen(szTmp);
		if(szTmp == "void")
        {
        	break
        }
        InsBufLine(hbuf, ln++, " Input: ")
		param = ""
		j = 0;
		k = 0;
		while(j < nlen)
		{
			if(k == 0)
			{
				if(szTmp[j] == " ")
				{
					k = 1
				}
			}
			else
			{
				param = Cat(param, szTmp[j])
			}
			j = j+1
		}
        i = i + 1
        InsBufLine(hbuf, ln++, "	@i@.@param@")
        iIns = 1
    }    
    closebuf(hTmpBuf)
    if(iIns == 0)
    {       
        InsBufLine(hbuf, ln++, " Input: 		None")
    }
	InsBufLine(hbuf, ln++, " Output: ")
 	InsBufLine(hbuf, ln++, " Return: 	")
 	InsBufLine(hbuf, ln++, " Other:  ")
    InsBufLine(hbuf, ln++, "*************************************************/")
}


/*********************************************************/
/*						输入函数						 */	
/*********************************************************/

/*************************************************
  Function: 	InsertWhile
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro InsertWhile()
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    hbuf = GetCurrentBuf()
    ln = sel.lnFirst
    if(sel.lnFirst == sel.lnLast && sel.ichFirst == sel.ichLim)
    {
        szLeft = CreateBlankString(sel.ichFirst)
        InsBufLine(hbuf, ln,szLeft)
        SetWndSel(hwnd,sel)
    }
    val = ExpandBraceLarge()
    szLeft = val.szLeft
    InsBufLine(hbuf, ln, "@szLeft@while ( # )")    
    if(sel.lnFirst == sel.lnLast && sel.ichFirst == sel.ichLim)
    {
        PutBufLine(hbuf,ln+2, "@szLeft@    #")
    }
    SetBufIns (hbuf, ln, strlen(szLeft)+7)
    SearchForward()
}

/*************************************************
  Function: 	RestoreCommand
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro RestoreCommand(hbuf,szCmd)
{
    if(szCmd == "ca")
    {
        szCmd = "case"
    }
    else if(szCmd == "sw") 
    {
        szCmd = "switch"
    }
    else if(szCmd == "el")
    {
        szCmd = "else"
    }
    else if(szCmd == "wh")
    {
        szCmd = "while"
    }
    else if(szCmd == "co")
    {
        szCmd = "config"
    }
    return szCmd
}

/*************************************************
  Function: 	WriteCommandProc
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro WriteCommandProc()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    if(sel.lnFirst > 0)
    {
        ln = sel.lnFirst - 1
    }
    else
    {
        stop
    }
    szLine = GetBufLine(hbuf,ln)
    szLine = TrimString(szLine)
    Cmd = RestoreCommand(hbuf,szLine)
    if(Cmd == "while")
    {
        InsertWhile()  
    }

    DelBufLine(hbuf,ln)
    SearchForward()
    stop
}

/*************************************************
  Function: 	ReadCommand
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro ReadCommand()
{
	Cmd=""
	while(1)
	{
		key = GetKey()
		if (!IsAltKeyDown(key) && !IsCtrlKeyDown(key) && !IsFuncKey(key))
		{
			ch = CharFromKey(key)
			if (Ascii(ch) == 13)
			{	
				break;
			}
			else if (Ascii(ch) == 8)
			{
				len = strlen(Cmd)
				if(len > 0)
				{
					Index = 0
					len = len-1
					NowCmd = Cmd
					Cmd = ""
					while(Index < len)
				    {
				       Cmd = Cat(Cmd, NowCmd[Index])
				       Index = Index+1
				    }
				}
			}
			else
			{
				Cmd = cat(Cmd,ch)
			}
		}
	}
	
	return Cmd
}

/*********************************************************/
/*						外部函数						 */	
/*********************************************************/

/*************************************************
  Function: InsertSysTime
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro InsertComment()
{
    sz = Ask("Enter Comment:")
    if (sz != "")
        CommentSz(sz);
}

/*************************************************
  Function: InsertIfbyTxl
  Description: #if 0 / #endif
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro InsertIf()
{
    ProgEnvInfo = GetProgramEnvironmentInfo ()
    Editor = GetAuthorbySelf()
 
    hwnd = GetCurrentWnd()
    lnFirst = GetWndSelLnFirst(hwnd)
    lnLast = GetWndSelLnLast(hwnd)
    LocalTime = GetSysTime(1)
 
    Year = LocalTime.Year
    Month = LocalTime.Month
    Day = LocalTime.Day
    Time = LocalTime.time
    hbuf = GetCurrentBuf()
    InsBufLine(hbuf, lnFirst, "#if 0 /* Edit By @Editor@ @Year@-@Month@-@Day@ */")
    InsBufLine(hbuf, lnLast+2, "#endif")
}

/*************************************************
  Function: 	InsertMoreLineComments
  Description: 
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro InsertMoreLineComments()
{
	hwnd=GetCurrentWnd()
	selection=GetWndSel(hwnd)
	LnFirst=GetWndSelLnFirst(hwnd)
	LnLast=GetWndSelLnLast(hwnd)
	hbuf=GetCurrentBuf()
	Ln=Lnfirst
	buf=GetBufLine(hbuf,Ln)
	len=strlen(buf)

	while(Ln <= Lnlast)
	{
		buf=GetBufLine(hbuf,Ln)
		if(buf=="")
		{
			Ln=Ln+1
			continue
		}	

		if(StrMid(buf,0,1) == "/")
		{
			if(StrMid(buf,1,2) == "/")
			{
				PutBufLine(hbuf,Ln,StrMid(buf,2,Strlen(buf)))
			}

		}

		if(StrMid(buf,0,1) != "/")
		{
			PutBufLine(hbuf,Ln,Cat("//",buf))
		}

		Ln = Ln + 1

	}
	SetWndSel( hwnd, selection )

}

/*************************************************
  Function: InsertIfdefbyTxl
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro InsertIfdef()
{
    sz = Ask("Enter ifdef condition:")
    if (sz != "")
        IfdefSz(sz);
}

/*************************************************
  Function: InsertIfndef
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro InsertIfndef()
{
    sz = Ask("Enter ifdnef condition:")
    if (sz != "")
        IfndefSz(sz);
}

/*************************************************
  Function: InsertFunctionHeaderbyTxl
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro InsertFunctionHeader()
{
    hBuff = GetCurrentBuf()
    FuncName = GetCurSymbol()
 	lnFirst = GetCommentsPos()

	symbol = GetSymbolLocation(FuncName)
    if (symbol == "")
    {

		hwnd = GetCurrentWnd()
	    sel = GetWndSel(hwnd)

        lnFirst = sel.lnFirst
        if(1 == GetLauguage())
        {
	        InsBufLine(hBuff, lnFirst++, "/*************************************************")
	    	InsBufLine(hBuff, lnFirst++, " Function: ")
	    	des = GetFunDescribe()
	    	InsBufLine(hBuff, lnFirst++, " Descroption: @des@")
	    	InsBufLine(hBuff, lnFirst++, " Input: 	")
	    	InsBufLine(hBuff, lnFirst++, " Output: 	")
	    	InsBufLine(hBuff, lnFirst++, " Return: 	")
	    	InsBufLine(hBuff, lnFirst++, " Other: 	")
	    	InsBufLine(hBuff, lnFirst++, "*************************************************/")
    	}
    	else
    	{
    		InsBufLine(hBuff, lnFirst++, "/*************************************************")
	    	InsBufLine(hBuff, lnFirst++, " 函 数 名: ")
	    	des = GetFunDescribe()
	    	InsBufLine(hBuff, lnFirst++, " 描    述: 		@des@")
	    	InsBufLine(hBuff, lnFirst++, " 输入参数: 	")
	    	InsBufLine(hBuff, lnFirst++, " 输出参数: 	")
	    	InsBufLine(hBuff, lnFirst++, " 返 回 值: 	")
	    	InsBufLine(hBuff, lnFirst++, " 其    他: 	")
	    	InsBufLine(hBuff, lnFirst++, "*************************************************/")
    	}
        return
    }
    if(1 == GetLauguage())
	{
		FuncHeadCommentEN(hBuff, lnFirst, FuncName)
	}
	else
	{
		FuncHeadCommentCN(hBuff, lnFirst, FuncName)
	}
    SaveBuf(hBuff)
}

/*************************************************
  Function: 	InsertFileHeader
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro InsertFileHeader()
{
 	hbuf = GetCurrentBuf()
 
    ProgEnvInfo = GetProgramEnvironmentInfo()
    Author = GetAuthor()
   
    szBufName = GetBufName(hbuf)
    Len = strlen(szBufName)
    FileName = ""
    if(0 != Len)
    {
        cch = Len
        while ("\\" != szBufName[cch])
        {
            cch = cch - 1
        }
 
        while(cch < Len)
        {
            cch = cch + 1
            FileName = Cat(FileName, szBufName[cch])
        }
    }
    lnFirst = 0

	if (1 == GetLauguage())
	{
		FileHeaderEN(hbuf,lnFirst,FileName,Author)
	}
	else
	{
		FileHeaderCN(hbuf,lnFirst,FileName,Author)
	}	


    Len = strlen(FileName)
    if(("h" == tolower(FileName[Len-1])) && ("." == FileName[Len-2]))
    {
        FileName = toupper(FileName)
        FileName[Len-2] = "_"
        szDef = "_"
        szDef = Cat(szDef,FileName)
        szDef = Cat(szDef,"_")
 
        hwnd = GetCurrentWnd()
        lnFirst = GetWndSelLnFirst(hwnd)
        LocalTime = GetSysTime(1)
 
        Year = LocalTime.Year
        Month = LocalTime.Month
        Day = LocalTime.Day
        Time = LocalTime.time
        hbuf = GetCurrentBuf()
       
        InsBufLine(hbuf,lnFirst++,"#ifndef @szDef@")
        InsBufLine(hbuf,lnFirst++,"#define @szDef@")
        InsBufLine(hbuf,lnFirst++,"")
        InsBufLine(hbuf,lnFirst++,"")
        InsBufLine(hbuf,lnFirst++,"")
		lnFirst = CreateCPP(hbuf,lnFirst);
  		InsBufLine(hbuf,lnFirst++,"")
        InsBufLine(hbuf,lnFirst++,"#endif /* ifndef @szDef@ Edit By @Author@ @Year@-@Month@-@Day@ */")
    }
    SaveBuf (hbuf)
}

/*************************************************
  Function: 	ConfigureSystem
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro ConfigureSystem()
{
    szLanguage = ASK("Please select language: 0 Chinese ,1 English");
    if(szLanguage != "")
    {
       SetReg ("LANGUAGE", szLanguage)
    }
    
    szName = ASK("Please input your name");
    if(szName != "")
    {
       SetReg ("MYNAME", szName)
    }
}

/*************************************************
  Function: 	NewFile
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro NewFile()
{

}

/*************************************************
  Function: 	ShowCmdMsg
  Description:
  Input:
  Output:
  Return:
  Others:
*************************************************/
macro ShowCmdMsg()
{	
	hwnd = GetCurrentWnd()
    if (hwnd == 0)
    {
    	stop
	}

    if(strlen(szMyName) == 0)
    {
        szMyName = Ask("Enter your name:")
        setreg(MYNAME, szMyName)
    }
    
	hbuf = GetCurrentBuf()
	LogLine1 = "                       Please Input Command:                                  "
	LogCmd = "   eg: config(co) new(n)"
	Log = cat(LogLine1,LogCmd)
	StartMsg(Log)


	Cmd = ReadCommand()
	
	NewCmd = RestoreCommand(hbuf,Cmd)
	
    if (NewCmd == "config")
    {
    	ConfigureSystem()
    }
    else if(NewCmd == "new")
    {
    	NewFile()
    }
    else
    {
    	Msg ("Error Command!")
    }
}

