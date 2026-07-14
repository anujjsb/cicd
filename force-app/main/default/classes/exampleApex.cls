public with sharing class exampleApex {
    public static void createA(){
        Account a1 = new Account();
        a1.name = 'Anuj';
        insert a1;

        Account a2 = new Account();
        a2.name = 'Rahul';
        a2.Website = 'https://test.com';
        insert a2;

        merge a1 a2;
    }
}