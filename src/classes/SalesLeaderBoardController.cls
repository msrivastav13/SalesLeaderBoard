public with sharing class SalesLeaderBoardController {
	
	@AuraEnabled
	public static list<SalesLeader> getSLDashboardData(){
		list<SalesLeader> lstsalesleader = new list<SalesLeader>();
		Integer THIS_YEAR =  System.date.today().year();
		map<String,decimal> mapUserIdByamount = new map<String,decimal>();
		for(AggregateResult ag:[SELECT SUM(Amount)sum,
										ownerId
										FROM Opportunity
										WHERE stageName='Closed Won' 
										AND CALENDAR_YEAR(CloseDate) = :THIS_YEAR
										GROUP BY OwnerId
										ORDER BY SUM(Amount) DESC 
										LIMIT 10]){
			mapUserIdByamount.put((String)ag.get('ownerId'),(Decimal)ag.get('sum'));
		}
		for(User u :[Select Id,Name,Email,FullPhotoUrl from User where ID IN :mapUserIdByamount.keyset()]){
			SalesLeader sleader = new SalesLeader(u.Name,u.Email,u.Id,mapUserIdByamount.get(u.Id),u.FullPhotoUrl);
			lstsalesleader.add(sleader);
		}
		lstsalesleader.sort();
		return lstsalesleader;
	}

	@AuraEnabled
	public static list<Opportunity> getlstopportunities(String ownerId){

		Integer THIS_YEAR =  System.date.today().year();

		return [Select Id,
						Name,
						Account.Name,
						CloseDate,
						Amount 
						FROM Opportunity
						WHERE ownerId =:ownerId
						AND stageName='Closed Won'
						AND CALENDAR_YEAR(CloseDate) = :THIS_YEAR
						ORDER BY CloseDate DESC LIMIT 100];
	}


	public class SalesLeader implements Comparable{

		@AuraEnabled
		public String fullname {get;set;}
		@AuraEnabled
		public String email {get;set;}
		@AuraEnabled
		public String userId {get;set;}
		@AuraEnabled
		public Decimal netsales {get;set;}
		@AuraEnabled
		public String photoURL {get;set;}

		public SalesLeader(String fullName,String email,String userId,decimal netsales,string photourl){
			this.fullname = fullname;
			this.email = email;
			this.userId = userId;
			this.netsales = netsales;
			this.photoURL = photourl;
		}

		// Implement the compareTo() method
	    public Integer compareTo(Object compareTo) {
	        SalesLeader compareTonetrevenue = (SalesLeader)compareTo;
	        if (netsales == compareTonetrevenue.netsales) return 0;
	        if (netsales < compareTonetrevenue.netsales) return 1;
	        return -1;       
	    }

	}

}