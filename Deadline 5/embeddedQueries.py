import mysql.connector
mydb=mysql.connector.connect(
    host='localhost',
    user='root',
    password='password'
)
mycursor=mydb.cursor()
mycursor.execute("use nnv;")



def validateAdmin(username,password):
    mycursor.execute(f"Select * from Admin where username='{username}' AND password='{password}'")
    data = mycursor.fetchall()
    if(len(data)==0):
        return False
    else:
        return True

def validateCustomer(emailID,password):
    mycursor.execute(f"Select * from Customer where email_ID='{emailID}' AND password='{password}'")
    data = mycursor.fetchall()
    if(len(data)==0):
        return False,None
    else:
        return True,data[0][1]

def isINT(number):
    try:
        int(number)
        return True
    except ValueError:
        return False
    
def isValidDate(date):
    if len(date) != 10:
        return False
    if (date[4] != '-' or date[7] != '-'):
        return False
    return True

def adminFunctions():
    AdminQueries=["SELECT userID AS customerID, CONCAT(first_name, ' ', COALESCE(middle_name, ''), ' ', last_name) AS name, CONCAT(house_number, ', ', street_name, ', ', city, ', ', state, ' - ', pincode) AS customer_address, age, MAX(ph.phone_number) AS primary_phone_number, email_ID AS email FROM Customer JOIN phone_number_customers ph ON Customer.phoneID = ph.phoneID GROUP BY customerID;",
    "SELECT c.userID, CONCAT(c.first_name, ' ', COALESCE(c.middle_name, ''), ' ', c.last_name) AS customer_name, SUM(t.amount) AS total_transaction_amount FROM Customer c JOIN CustomersTransactions ct ON c.userID = ct.userID JOIN Transactions t ON ct.transactionID = t.transactionID GROUP BY c.userID ORDER BY total_transaction_amount DESC LIMIT 3;"]
    while True:
        print()
        print("1. Customers Stats")
        print("2. Top 3 Customers With Highest Transactions")
        print("3. Add a Coupan")
        print("4. Logout")
        choice=input("Enter Your Option: ")
        print()
        if(choice=="1"):
            mycursor.execute(AdminQueries[0])
            data = mycursor.fetchall()
            for tupple in data:
                print("------------------------")
                print("Customer ID: ",tupple[0])
                print("Full Name: ",tupple[1])
                print("Address: ",tupple[2])
                print("Age: ",tupple[3])
                print("Phone Number: ",tupple[4])
                print("Email ID: ",tupple[5])
                print("------------------------")

        elif(choice=="2"):
            mycursor.execute(AdminQueries[1])
            data = mycursor.fetchall()
            for tupple in data:
                print("------------------------")
                print("Customer ID: ",tupple[0])
                print("Full Name: ",tupple[1])
                print("Transation Amount: ",tupple[2])
                print("------------------------")

        elif(choice=="3"):
            mycursor.execute("Select Max(coupanID) from coupans;")
            max_coupanID= mycursor.fetchall()
            max_coupanID= max_coupanID[0][0]
            coupan_code=input("Enter Coupan Code: ")
            discount=input("Enter Discount Percentage: ")
            expiry=input("Enter Expiry Date (YYYY-MM-DD): ")
            description=input("Enter Description: ")
            if((isINT(discount)==True) and (isValidDate(expiry)==True)):
                try:
                    mycursor.execute(f"INSERT INTO Coupans VALUES (1, {int(max_coupanID)+1}, '{expiry}', {discount}, '{description}', '{coupan_code}')")
                    mydb.commit()
                    print("Successfully Inserted.......")
                except :
                    print("Cant Insert, Wrong Values!!!!!")
            else:
                print("Cant Insert, Wrong Values!!!!!")
        elif(choice=="4"):
            print("Logged Out.....")
            return
        else:
            print("Wrong Option!!!!!")

def checkLogs(customerID):
    mycursor.execute(f"select * from log_table where user_id={customerID}")
    data = mycursor.fetchall()
    if(data==[]):
        return False
    else:
        return True

def clearlogs(customerID):
    mycursor.execute(f"Delete from log_table where user_id={customerID}")
    mydb.commit()

def customerFunctions(customerID):
    customerQueries=[f"Select * from Customer where userID={customerID}","Select * from Product",f"Select * from orders where userID ={customerID}",f"Select * from CustomersTransactions as CT JOIN Transactions as T ON CT.transactionID = T.transactionID where CT.userID={customerID}"]
    while True:
        print()
        print("1. View My Profile")
        print("2. Buy A Product")
        print("3. View Orders")
        print("4. Show Past Transactions")
        print("5. Logout")
        print()
        choice=input("Enter Your Option: ")
        if(choice=="1"):
            mycursor.execute(customerQueries[0])
            for data in mycursor.fetchall():
                print("First Name: ",data[3])
                print("Middle Name: ",data[4])
                print("Last Name: ",data[5])
                print("Email ID: ",data[6])
                print("Unique PhoneID: ",data[7])
                print("Date Of Birth: ",data[8].strftime("%Y-%m-%d"))
                print("Age: ",data[9])
                print("House Number: ",data[10])
                print("Street Name: ",data[11])
                print("City: ",data[12])
                print("Pincode: ",data[13])
                print("State: ",data[14])

        elif(choice=="2"):
            result=checkLogs(customerID)
            if(result==True):
                print("Cant Place Order Right Now!!!!!\n Maybe Bot Activity!!!!!")
                clearlogs(customerID)
                return
            print("Product Catalogue:-")
            mycursor.execute(customerQueries[1])
            availableProducts=[]
            for data in mycursor.fetchall():
                print("-----------------")
                print("Product ID: ",data[1])
                print("Product Name: ",data[2])
                print("Product Description: ",data[3])
                print("Product Price: ",data[4])
                print("-----------------")
                availableProducts.append(str(data[1]))
            print("\nChoose Your Product\n")
                
            product_choice=input("Enter the Product ID: ")
            if(product_choice in availableProducts):
                product_quantity=input("Enter Desired quantity (1 to 3): ")
                mycursor.execute(f"Select price from Product where productID={product_choice}")
                product_price=mycursor.fetchall()[0][0]
                product_price=float(product_price)
                mycursor.execute("Select Max(orderID) from orders;")
                max_order_id=mycursor.fetchall()[0][0]
                order_address=[]
                mycursor.execute(customerQueries[0])
                data=mycursor.fetchall()[0]
                order_address.append(data[10])
                order_address.append(data[11])
                order_address.append(data[12])
                order_address.append(data[13])
                order_address.append(data[14])
                try:
                    mycursor.execute(f"INSERT INTO Orders Values ({int(max_order_id)+1},{customerID},{order_address[0]},'{order_address[1]}','{order_address[2]}','{order_address[3]}','{order_address[4]}',{int(product_quantity)*int(product_price)},NOW()) ")
                    mycursor.execute(f"INSERT INTO Order_has_products Values ({int(max_order_id)+1},{product_choice},{product_quantity});")
                    mydb.commit()
                except mysql.connector.Error as e:
                    print("Order Failed: ",e)
                    continue
                print("Order Placed.......")
                print("Transaction Initiated..........")
                try:
                    mycursor.execute(f"Select T.transactionID from transaction_for_order as T_order JOIN Transactions as T ON t_order.transactionID = T.transactionID where T_order.orderID={int(max_order_id)+1}")
                    data = mycursor.fetchall()
                    transaction_id=data[0][0]
                    payment_name=input("Enter The Payment Gateway: ")
                    mycursor.execute(f"UPDATE Transactions Set transactions_status = 'Completed' , payment_name='{payment_name}' , amount= {int(product_quantity)*int(product_price)} where transactionID= {transaction_id}")
                    mydb.commit()
                except mysql.connector.Error as e:
                    print("Transaction Failed!!!!!!",e)
                    continue
                print("Transaction Successfull..............")
                print("Order Purchased Successfully.........")
            else:
                print("Wrong Product ID Entered!!!!")
        
        elif(choice=="3"):
            mycursor.execute(customerQueries[2])
            items=mycursor.fetchall()
            if(items==[]):
                print("You Have Placed No Orers Yet!!!!!!")
            else:
                for data in items:
                    print("----------------------")
                    print("Order ID: ",data[0])
                    print("House Number: ",data[2])
                    print("Street Name: ",data[3])
                    print("City: ",data[4])
                    print("Pincode: ",data[5])
                    print("State: ",data[6])
                    print("Total Amount: ",data[7])
                    print("----------------------")
        
        elif(choice=="4"):
            mycursor.execute(customerQueries[3])
            data = mycursor.fetchall()
            if(data==[]):
                print("You Have Not Made Any Transaction Yet")
            else:
                for item in data:
                    print("----------------")
                    print("Transaction ID: ",item[2])
                    print("Date Of Transaction: ",item[3].strftime("%Y-%m-%d"))
                    print("Transaction Amount: ",item[4])
                    print("Transaction Status: ",item[5])
                    print("Payment Method Used: ",item[6])
                    print("----------------")
        
        elif(choice=="5"):
            print("Loging Out.........")
            return
        
        else:
            print("Wrong Option!!!!!")

def signUP(emailID,password):
    try:
        first_name = input("First Name: ")
        middle_name = input("Middle Name (leave blank if none): ")
        last_name = input("Last Name: ")
        date_of_birth = input("Date of Birth (YYYY-MM-DD): ")
        age = int(input("Age: "))
        house_number = int(input("House Number: "))
        street_name = input("Street Name: ")
        city = input("City: ")
        pincode = int(input("Pincode: "))
        state = input("State: ")
    except :
        print("Wrong Input Provided!!!!")
        return
    if(isValidDate(date_of_birth)==True):
        mycursor.execute("Select Max(userID) from Customer;")
        max_customer_id=mycursor.fetchall()
        max_customer_id=max_customer_id[0][0]
        try:
            mycursor.execute(f"INSERT INTO Customer VALUES (1,{int(max_customer_id)+1},'{password}','{first_name}','{middle_name}','{last_name}','{emailID}',{int(max_customer_id)+1},'{date_of_birth}',{age},{house_number},'{street_name}','{city}',{pincode},'{state}');")
            mydb.commit()
        except mysql.connector.Error as error:
            if(error.errno==3819):
                print("Too Small to Register!!!! or Password Must be Alpha Numeric!!!!!!")
            else:
                print(error)
                print("Cant Register!!!!!")
            return
        print("Successfully Registered..........")
    else:
        print("Wrong DOB Format!!!!!")
        return
    


while True:
    print()
    print("1. Login As Admin")
    print("2. Login As Customer")
    print("3. SignUP As a new Customer")
    print("4. EXIT")
    choice=input("Enter Your Option: ")
    print()
    if(choice=="1"):
        username=input("Enter Admin Username: ")
        password=input("Enter your password: ")
        result= validateAdmin(username,password)
        if(result==True):
            adminFunctions()
        else:
            print("Wrong Details!!!!!")

    elif(choice=="2"):
        emailID=input("Enter your Email ID: ")
        password=input("Enter your password: ")
        result,customerID=validateCustomer(emailID,password)
        if(result==True):
            customerFunctions(customerID)
        else:
            print("Invalid Customer!!!!!")

    elif(choice=="3"):
        emailID=input("Enter the Email ID: ")
        password=input("Enter the password: ")
        result,customerID=validateCustomer(emailID,password)
        if(result==True):
            print("You are Already Registered with EMAIL ID: ",emailID,"!!!!!")
        else:
            signUP(emailID,password)
        
    elif(choice=="4"):
        print("Exiting The Program......")
        mydb.close()
        break
    
    else:
        print("Wrong Option!!!!!")
        