trigger trg2 on Contact(after Insert,after Update)
{   
    Set<Id> accId = new Set<Id>();
    List<Account> accList = new List<Account>();
      
    for(Contact con : trigger.new)
    {
        if(con.AccountId != null)
        {
            accId.add(con.AccountId);
        }
    }  
    Map<Id,Account> accMap = new Map<Id,Account>([Select Id,Phone,Description from Account where Id IN : accId]);
    if(trigger.isAfter && trigger.isInsert)
    { 
        for(Contact con : trigger.new)
        {
            Account acc = accMap.get(con.AccountId);
            acc.Phone = con.Phone;
            accList.add(acc);
        }
        if(!accList.isEmpty())
        {
            update accList;
        }
    }   
    if(trigger.isAfter && trigger.isUpdate)
    { 
        for(Contact con : trigger.new)
        {
            Account ac = accMap.get(con.AccountId);
            ac.Description += ' '+con.Phone;
            accList.add(ac);
        }
        if(!accList.isEmpty())
        {
            update accList;
        }
    }
}
