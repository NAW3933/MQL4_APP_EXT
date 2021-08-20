/*
 	SignalRSI.mqh
 	For framework version 1.0
 	
   Copyright 2013-2020, Orchard Forex
   https://www.orchardforex.com
 
*/
 
#include	"../../Framework.mqh"

class CSignalRSI : public CSignalBase {

private:

protected:	// member variables

   double      mBuyLevel;
   double      mSellLevel;
	
public:	// constructors

	CSignalRSI(string symbol, ENUM_TIMEFRAMES timeframe,
								double buyLevel, double sellLevel)
								:	CSignalBase(symbol, timeframe)
								{	Init(buyLevel, sellLevel);	}
	CSignalRSI(double buyLevel, double sellLevel)
								:	CSignalBase()
								{	Init(buyLevel, sellLevel);	}
	~CSignalRSI()	{	}
	
	int			Init(double buyLevel, double sellLevel);

public:

	virtual void								UpdateSignal();

};

int		CSignalRSI::Init(double buyLevel, double sellLevel) {

	if (InitResult()!=INIT_SUCCEEDED)	return(InitResult());

   mBuyLevel = buyLevel;
   mSellLevel = sellLevel;
			
	return(INIT_SUCCEEDED);
	
}

void		CSignalRSI::UpdateSignal() {

	double	level1	=	GetIndicatorData(0, 1);
	double	level2	=	GetIndicatorData(0, 2);

   mEntrySignal = OFX_SIGNAL_NONE; //this strategy has no exit signal
   
   if((level1<=mSellLevel)&&!(level2<=mBuyLevel)){  //Crossed below sell level
      mEntrySignal   =  OFX_SIGNAL_SELL;
   }
   else
   if ((level1>=mBuyLevel)&&!(level2>=mBuyLevel)){ //Crossed above buy level
      mEntrySignal = OFX_SIGNAL_BUY;
   } else
   {
      mEntrySignal = OFX_SIGNAL_NONE;
   }


	return;
	
}

	
