/*
Created By- Keyur Shah
Description-will perform authentication of logged in user by Token stored in cookie and passed in URL parameter 
*/
public class AuthenticateUser{
    public static boolean compareSecurityToken(){
      Map<String,Cookie> cookieMap=ApexPages.currentPage().getCookies();
      System.debug(cookieMap);
      String urlToken=ApexPages.currentpage().getParameters().get('DAIS_tag');
      if(urlToken!=null && urlToken!=''){
          if(cookieMap.values().size()>0){
              if(cookieMap.get('securityToken')!=null){
                  String cookieToken=String.valueof(cookieMap.get('securityToken').getValue());
                  System.debug('cookieToken---'+cookieToken);
                  boolean flag=cookieToken.equals(urlToken);
                  System.debug(urlToken);
                  System.debug('flag---'+flag);
                  return flag;
              }
              else{
                  Cookie ck=new Cookie('securityToken',urlToken,null,50400,false);
                  System.debug('ck---'+ck);
                  Apexpages.currentPage().setCookies(new Cookie[]{ck});
                  return true;
              }
          }
          else{
              Cookie ck=new Cookie('securityToken',urlToken,null,50400,false);
              Apexpages.currentPage().setCookies(new Cookie[]{ck});
              return true;
          }
      }
      else{
          System.debug('inside last else part');
          return false;
      }
      
  }        
}