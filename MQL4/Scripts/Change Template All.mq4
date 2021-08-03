//+------------------------------------------------------------------+
//|                                           ChangeTemplate-All.mq4 |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, zznbrm"
#property show_inputs

#include <WinUser32.mqh>

#import "user32.dll"
   int      PostMessageA(int hWnd,int Msg,int wParam,int lParam);
   int      GetWindow(int hWnd,int uCmd);
   int      GetParent(int hWnd);
#import

extern int templateIndex = 0;
                   
int start()
{      
   bool blnContinue = true;   
   int intParent = GetParent( WindowHandle( Symbol(), Period() ) );   
   int intChild = GetWindow( intParent, GW_HWNDFIRST );  
     
   if ( intChild > 0 )   
   {
      if ( intChild != intParent )   PostMessageA( intChild, WM_COMMAND, 34800 + templateIndex, 0 );
   }
   else      blnContinue = false;   
   
   while( blnContinue )
   {
      intChild = GetWindow( intChild, GW_HWNDNEXT );   
   
      if ( intChild > 0 )   
      { 
         if ( intChild != intParent )   PostMessageA( intChild, WM_COMMAND, 34800 + templateIndex, 0 );
      }
      else   blnContinue = false;   
   }
   
   // Now do the current window
   PostMessageA( intParent, WM_COMMAND, 34800 + templateIndex, 0 );
}



