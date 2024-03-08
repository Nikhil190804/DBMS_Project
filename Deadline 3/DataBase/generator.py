import csv

#GENERIC FUNCTION FOR GENERATOR
def automation(file_name,need_quote_at_this_index):
    file1=open(f"Dataset/{file_name}.csv",'r',encoding="utf-8")
    file2=open(f"DataPopulation/{file_name}.txt",'w',encoding="utf-8")
    file2.write("USE NNV;\n")
    file2.flush()
    reader = csv.reader(file1)
    string = f"INSERT INTO {file_name} ("
    first_row = next(reader)
    for attribute_name in first_row:
        string+=attribute_name+", "
    last=len(string)-2
    string=string[:last]
    string+=") VALUES ("
    temp_string=""
    index_counter=0
    for row_data in reader:
        index_counter=0
        temp_string=string
        for data in row_data:
            if(index_counter in need_quote_at_this_index):
                new_format_data="'"+data+"'"
                data=new_format_data
            temp_string+=data+", "
            index_counter+=1
        last_index=len(temp_string)-2
        temp_string=temp_string[:last_index]
        temp_string+=" );\n"
        file2.write(temp_string)
    file1.close()
    file2.flush()
    file2.close()


#FUNCTION CALLS TO PRODUCE THE DESIRED OUTPUT
automation("Admin",[1,2,3])
automation("Customer",[2,3,4,5,6,11,12,14])
automation("phone_number",[0])
automation("Coupans",[5,6])
automation("Product",[3,4])
automation("product_images",[2])
automation("Category",[3])
automation("Delivery_Agent",[3,4,5])
automation("Transactions",[5,6])
automation("Reviews",[3])
automation("Order",[4,5,7])
automation("Cart",[])