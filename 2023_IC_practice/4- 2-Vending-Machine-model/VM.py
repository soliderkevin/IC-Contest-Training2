def VM_algorithm_modeling(insert_nickel,insert_dime,insert_quarter):
    #Price of the drinks
    cola_price = 4
    soda_price = 2
    lemonade_price = 1
    lemonade = 0
    soda = 0
    cola = 0
    #
    Total_amount = insert_dime*0.1  + insert_quarter*0.25 +  insert_nickel*0.5
    C_Total_amount = Total_amount
    while 0 < Total_amount:
        sel_drink_reg = input(str("Select the drink: COLA:4$, SODA20$, LEMONADE:1$ or W(withdraw) or C(Clear):"))
        if sel_drink_reg == 'COLA':
            if Total_amount >= cola_price:
                print("The cost is",cola_price)
                Total_amount = Total_amount - cola_price
                cola = cola + 1
                print("You've ordered",cola,"cans of cola.")
                print("With rest of the amount",Total_amount)
            else:
                print("insufficient money:, your money is:",Total_amount)
        elif sel_drink_reg == 'SODA':
            if Total_amount >=soda_price:
                print("The cost is",soda_price) 
                Total_amount = Total_amount - soda_price        
                soda = soda + 1
                print("You've ordered",soda,"cans of soda.")
                print("With rest of the amount",Total_amount)   
            else:
                print("insufficient money:, your money is:",Total_amount)
        elif sel_drink_reg == 'LEMONADE':
            if Total_amount >= lemonade_price:
                print("The cost is ",lemonade_price)
                Total_amount = Total_amount - lemonade_price          
                lemonade = lemonade + 1
                print("You've ordered",lemonade,"cans of lemonade.")
                print("With rest of the amount",Total_amount)
            else:
                print("insufficient money:, your money is:",Total_amount)            
        
        elif sel_drink_reg == 'W':
            print("your amount is",Total_amount,"dollars.")
            withdraw = 1
            withdraw = Total_amount
            Total_amount = 0
            print("Total amount of money withdrawn is:",withdraw)
        elif sel_drink_reg == 'C':
            Total_amount = C_Total_amount
            print("your amount is returned, and with",Total_amount,"dollars.")

        else:
            print("INPUT ERROR!, please reselect or choose withdraw")
            
    total_price = cola*cola_price+ soda*soda_price+ lemonade*lemonade_price
    print("Total Price:",total_price)
    print("You've purchased Cola amount:",cola,"Soda amount:",soda,"lemonade amount:",lemonade)

    #Confirmation
    sel = 1
    while(sel):
        selection = input(str("Confirmed?(YES/NO):"))
        if selection == 'YES':
            print("Total price:",total_price)
            print("Change amount:",withdraw)
            sel = 0
        elif selection == 'NO':
            withdraw = Total_amount
            ("Money has returned",withdraw)
            sel = 0

        else:
            print("INPUT ERROR!, Please reselect.")
    print("Your change:",withdraw,"$")






insert_nickel = int(input("Insert nickel:"))
insert_quarter = int(input("Insert quarter:"))
insert_dime = int(input("Insert dime:"))
VM_algorithm_modeling(insert_nickel,insert_dime,insert_quarter)