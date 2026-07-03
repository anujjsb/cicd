public class abcGetChartData {
    @AuraEnabled
    public static Map<String, Object> getChartData(Date startDate , Date endDate , String status,String region,String customerName){
        try {
            System.debug('startDate => '+startDate + ' endDate => '+endDate + ' status => '+status + ' region => '+ region + ' customerName-> '+customerName);
            // String queryString = [Select Id,category__c,customer_name__c,order_date__c,product_name__c,quantity__c,region__c,sales_amount__c,status__c from sales_record__c];
            String queryString = 'Select Id,category__c,sales_amount__c,status__c,region__c,customer_name__c ';
            List<String> stringList = new List<String>();
            if(startDate != null){
                string s = ' createdDate >= :startDate';
                stringList.add(s);
            }
            if(endDate != null){
                string s = ' createdDate <= :endDate';
                stringList.add(s);
            }
            if(String.isNotBlank(status) && status != 'All'){
                string s = 'status__c = :status';
                // queryString += ',status__c';
                stringList.add(s);
            }
            if(String.isNotBlank(region) && region != 'All'){
                string s = 'region__c = :region';
                // queryString += ',region__c';
                stringList.add(s);
            }
            if(String.isNotBlank(customerName)){
                string s = 'customer_name__c = :customerName';
                // queryString += ',customer_name__c';
                stringList.add(s);
            }

            if(string.isBlank(customerName) && endDate == null && startDate == null && region == 'All' && status == 'All'){
                queryString = queryString +' from sales_record__c';
            }
            else{
                queryString = queryString +' from sales_record__c Where ' + String.join(stringList, ' AND ');
            }

            System.debug('queryString is -> '+queryString);
            // for (AggregateResult ar : listData) {
            //     System.debug('ar.get -> '+ar.get('category__c'));
            //     System.debug('ar.get -> '+ar.get('expr0'));
            // }
            // return listData;
            List<sales_record__c> listData = Database.query(queryString);
            integer totalCount = 0;
            integer furnitureCount = 0;
            integer electronicsCount = 0;
            integer groceryCount = 0;

            decimal southSale = 0;
            decimal northSale = 0;
            decimal eastSale = 0;
            decimal westSale = 0;

            decimal totalSales = 0;
            integer totalOrder = listData.size();
            integer totalDeliveredOrder = 0;
            integer totalCancelledOrder = 0;

            for(sales_record__c item : listData){
                if(item.category__c == 'Electronics'){
                    electronicsCount++;
                }
                if(item.category__c == 'Furniture'){
                    furnitureCount++;
                }
                if(item.category__c == 'Grocery'){
                    groceryCount++;
                }

                if(item.region__c == 'south'){
                    if(item.sales_amount__c != null){
                        southSale  += item.sales_amount__c;
                    }
                }
                if(item.region__c == 'north'){
                    if(item.sales_amount__c != null){
                        northSale  += item.sales_amount__c;
                    }
                }
                if(item.region__c == 'east'){
                    if(item.sales_amount__c != null){
                        eastSale  += item.sales_amount__c;
                    }
                }
                if(item.region__c == 'west'){
                    if(item.sales_amount__c != null){
                        westSale  += item.sales_amount__c;
                    }
                }
                if(item.status__c == 'delivered'){
                    totalDeliveredOrder++;
                }
                if(item.status__c == 'cancelled'){
                    totalCancelledOrder++;
                }
                totalCount++;
            }

            totalSales = southSale + northSale + eastSale + westSale;
            System.debug('totalSales -> '+totalSales);

            Map<String, Object> response = new Map<String, Object>();
            response.put('eCount', electronicsCount);
            response.put('fCount', furnitureCount);
            response.put('gCount', groceryCount);
            response.put('southSale',southSale);
            response.put('northSale', northSale);
            response.put('eastSale',eastSale);
            response.put('westSale', westSale);

            response.put('totalOrder', totalOrder);
            response.put('totalSales', totalSales);
            response.put('totalDelivered',totalDeliveredOrder);
            response.put('totalCancelled', totalCancelledOrder);
            System.debug('response is -> '+response);


            return response;
        } catch (Exception e) {
            System.debug('error is -> '+e.getCause());
            System.debug('error message -> '+e.getMessage() + ' '+e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
}