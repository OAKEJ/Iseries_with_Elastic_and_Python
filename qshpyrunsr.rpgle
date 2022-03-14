      **************************************************************************
      * COPYRIGHT 2022 SWIFT TRANSPORTATION COMPANY, INCORPORATED              *
      * This software is proprietary information for Swift Transportation      *
      * Company, Inc.                                                          *
      **************************************************************************
      * Program Name: Qshpyrunsr                                               *
      * Author......: Lyle Larsen                                              *
      * Date........: 01/25/22                                                 *
      * Purpose.....: Service Program to call Python scripts and interact with *
      *               the script response.                                     *
      * CCR#........:                                                          *
      * Notes.......: Library QSHONI must be in the library list               *
      **************************************************************************
      * Purpose: Run a python script stored on the IFS.
      *          Provide methods to retrieve the result of running the scripts.
      * How to use:
      *  1) Ensure the calling program has bnddir('SWIFT') in the h-specs.
      *  2)
      **************************************************************************
      *           M O D I F I C A T I O N   H I S T O R Y
      * Initials   Date     UserID      Description
      *   XXX    mm/dd/yy   xxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      **************************************************************************
      **************************************************************************
       ctl-opt
         copyright('COPYRIGHT 2022 SWIFT TRANSPORTATION INCORPORATED')
         debug
         indent('| ')
         option(*srcstmt : *nodebugio)
         datfmt(*iso)
         timfmt(*iso)
         nomain;

       // Copy Files
       /include larsl/qrpglecpy,qshpyrnc_h
       /include larsl/qrpglecpy,qshpyrns_h

       // ---------------------------------------------------------------------
       // Procedure : qshpyrunsr_runPythonScript
       // Purpose...: Runs a Python script on the IFS.
       // Returns...: Nothing
       // ---------------------------------------------------------------------
       dcl-proc qshpyrunsr_runPythonScript export;
         dcl-pi *n;
           inScriptDirectory   char(255) const;                  // IFS path to script folder
           inScriptFile        char(255) const;                  // name of the script to execute
           inArgs              likeds(argStructT)                // arguments list, up to 40
                               const options(*nopass);
           inPythonVersion     char(5)   const options(*nopass); // one of '2' or '3'
           inPythonBinaryPath  char(255) const options(*nopass); // pass '*default' to use dtaara qshoni/pypath
           inSetPackagePath    char(4)   const options(*nopass); // Set package path before running cmd - *YES or *NO
           inDisplayStdOut     char(4)   const options(*nopass); // Display outfile contents - *YES or *NO
           inLogStdOutToJobLog char(4)   const options(*nopass); // Log stdout to current job log - *YES or *NO
           inPrintStdOut       char(4)   const options(*nopass); // Print stdout to a spool file - *YES or *NO
           inDeleteStdOut      char(4)   const options(*nopass); // Clean up IFS stdout after processing - *YES or *NO
           inIfsStdOut         char(4)   const options(*nopass); // Copy stdout to an IFS file - *YES or *NO
           inIfsFile           char(255) const options(*nopass); // IFS file for stdout.  Required if ifsStdOut = *YES
           inIfsOption         char(10)  const options(*nopass); // IFS file option. *REPLACE file or *ADD to file
           inCcsid             char(10)  const options(*nopass); // CCSID value.  37 or *SAME to use current job value
           inPrintSpoolFile    char(10)  const options(*nopass); // Name of spool file when printStdOut = *YES
           inPrintUserData     char(10)  const options(*nopass); // Name of spool file user data when printStdOut = *YES
           inPrintText         char(30)  const options(*nopass); // Name of spool file print text when printStdOut = *YE
         end-pi;

         // Local variables used to call Qshpyrunc
         dcl-s scriptDirectory   like(inScriptDirectory);
         dcl-s scriptFile        like(inScriptFile);
         dcl-ds args             likeds(argStructT)        inz(*likeds);
         dcl-s pythonVersion     like(inPythonVersion)     inz('3');
         dcl-s pythonBinaryPath  like(inPythonBinaryPath)  inz('*DEFAULT');
         dcl-s setPackagePath    like(inSetPackagePath)    inz('*YES');
         dcl-s displayStdOut     like(inDisplayStdOut)     inz('*NO');
         dcl-s logStdOutToJobLog like(inLogStdOutToJobLog) inz('*NO');
         dcl-s printStdOut       like(inPrintStdOut)       inz('*NO');
         dcl-s deleteStdOut      like(inDeleteStdOut)      inz('*YES');
         dcl-s ifsStdOut         like(inIfsStdOut)         inz('*NO');
         dcl-s ifsFile           like(inIfsFile)           inz('');
         dcl-s ifsOption         like(inIfsOption)         inz('*REPLACE');
         dcl-s ccsid             like(inCcsid)             inz('*SAME');
         dcl-s printSpoolFile    like(inPrintSpoolFile)    inz('');
         dcl-s printUserData     like(inPrintUserData)     inz('*NONE');
         dcl-s printText         like(inPrintText)         inz('*NONE');

         scriptDirectory = inScriptDirectory;
         scriptFile = inScriptFile;

         exsr setParms;

         qshpyrunc(
           scriptDirectory :
           scriptFile :
           args :
           pythonVersion :
           pythonBinaryPath :
           setPackagePath :
           displayStdOut :
           logStdOutToJobLog :
           printStdOut :
           deleteStdOut :
           ifsStdOut :
           ifsFile :
           ifsOption :
           ccsid :
           printSpoolFile :
           printUserData :
           printText
         );

         // ---------------------------------------------------------------------
         // Subroutine : setParms
         // Purpose....: Set optional parameters passed to the procedure
         // ---------------------------------------------------------------------
         begsr setParms;

           if %parms() >= 3;
             args = inArgs;
           endif;

           if %parms() >= 4;
             pythonVersion = inPythonVersion;
           endif;

           if %parms() >= 5;
             pythonBinaryPath = inPythonBinaryPath;
           endif;

           if %parms() >= 6;
             setPackagePath = inSetPackagePath;
           endif;

           if %parms() >= 7;
             displayStdOut = inDisplayStdOut;
           endif;

           if %parms() >= 8;
             logStdOutToJobLog = inLogStdOutToJobLog;
           endif;

           if %parms() >= 9;
             printStdOut = inPrintStdOut;
           endif;

           if %parms() >= 10;
             deleteStdOut = inDeleteStdOut;
           endif;

           if %parms() >= 11;
             ifsStdOut = inIfsStdOut;
           endif;

           if %parms() >= 12;
             ifsFile = inIfsFile;
           endif;

           if %parms() >= 13;
             ifsOption = inIfsOption;
           endif;

           if %parms() >= 14;
             ccsid = inCcsid;
           endif;

           if %parms() >= 15;
             printSpoolFile = inPrintSpoolFile;
           endif;

           if %parms() >= 16;
             printUserData = inPrintUserData;
           endif;

           if %parms() = 17;
             printText = inPrintText;
           endif;

         endsr;

       end-proc;

       // ---------------------------------------------------------------------
       // Procedure : qshpyrunsr_getFirstResult
       // Purpose...: Retrieves the first row of Qtemp/Stdoutqsh, which is
       //             populated with results after calling Qshpyrunc.
       // Returns...: Data row as a 1000A string
       // ---------------------------------------------------------------------
       dcl-proc qshpyrunsr_getFirstResult export;
         dcl-pi *n;
           outResult char(1000);
         end-pi;

         exec sql
           select stdoutqsh into :outResult
           from qtemp/stdoutqsh
           fetch first row only;

       end-proc;

       // ---------------------------------------------------------------------
       // Procedure : qshpyrunsr_getManyResults
       // Purpose...: Retrieves the contents of Qtemp/Stdoutqsh, which is
       //             populated with results after calling Qshpyrunc.
       //             Each row of Stdoutqsh is placed in outResultList along
       //             with a total row count.
       // Returns...: Nothing
       // ---------------------------------------------------------------------
       dcl-proc qshpyrunsr_getManyResults export;
         dcl-pi *n;
           outResultList  char(1000) dim(maxQshResultCount);
           outResultCount int(10);
         end-pi;

         dcl-s rowsToFetch int(10) inz(%elem(fetch));
         dcl-s rowsFetched int(10) inz;
         dcl-s currentIndex int(10) inz(1);
         dcl-c fetchRowCount const(999);

         dcl-ds fetch dim(fetchRowCount) qualified;
           stdoutqsh char(1000);
         end-ds;

         exsr resetOutputParameters;
         exsr executeQuery;
         exsr openCursor;
         exsr fetchNext;

         dow sqlcod = 0;

           // If we have more items than we have room for, eject.
           if (currentIndex + rowsFetched > maxQshResultCount);
             leave;
           endif;

           // Copy fetched values into array
           exsr copyFetchToResult;

           // Increment current index by number of elements copied
           currentIndex += rowsFetched;

           exsr fetchNext;

         enddo;

         exsr closeQuery;

         outResultCount = currentIndex - 1;

         // ---------------------------------------------------------------------
         // Subroutine : resetOutputParameters
         // Purpose....: Reset return variables to default states
         // ---------------------------------------------------------------------
         begsr resetOutputParameters;
           outResultCount = 0;
           clear outResultList;
         endsr;

         // ---------------------------------------------------------------------
         // Subroutine : executeQuery
         // Purpose....: Execute the SQL query
         // ---------------------------------------------------------------------
         begsr executeQuery;
           exec sql
             declare qCursor cursor for
             select stdoutqsh
             from qtemp/stdoutqsh;
         endsr;

         // ---------------------------------------------------------------------
         // Subroutine : openCursor
         // Purpose....: Open the SQL cursor
         // ---------------------------------------------------------------------
         begsr openCursor;
           exec sql open qCursor;

           if sqlcod = -502;
             exec sql close qCursor;
             exec sql open qCursor;
           endif;
         endsr;

         // ---------------------------------------------------------------------
         // Subroutine : fetchNext
         // Purpose....: Fetch the next set of records from the query
         // ---------------------------------------------------------------------
         begsr fetchNext;
           exec sql fetch next from qCursor for :rowsToFetch rows into :fetch;
           rowsFetched = sqler3;
         endsr;

         // ---------------------------------------------------------------------
         // Subroutine : copyFetchToResult
         // Purpose....: Copy the rows fetched to the output data array
         // ---------------------------------------------------------------------
         begsr copyFetchToResult;
           %subarr(outResultList : currentIndex : rowsFetched) = fetch;
         endsr;

         // ---------------------------------------------------------------------
         // Subroutine : closeQuery
         // Purpose....: Close the sql cursor
         // ---------------------------------------------------------------------
         begsr closeQuery;
           exec sql close qCursor;
         endsr;
       end-proc;
