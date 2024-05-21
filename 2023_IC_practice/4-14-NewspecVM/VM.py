import time

#Variable declaration
Total_amount = 0
sel = 0
Drink = ' '
Purchase_Signal =0
Change_Signal = 0
CONFIRMATION_SIGNAL = 0
Drop_Signal = 0
Active_Signal = 1
Select_Signal_reg = '0000'
w_price = 20
b_price = 30
c_price = 40
j_price = 50

#Purchasing state:
while Active_Signal == 1:
    print("Welcome to the Vending Machine, we're providing 4 different drinks to you. \n")
    while sel == 0:
        Token_Insert = int(input('Insert 10:10$ or 50:50$: \n'))

        if Token_Insert == 10:
            Total_amount = Total_amount+10
            print('Inserted 10$ \n')
        elif Token_Insert == 50:
            Total_amount = Total_amount+50
            print('Inserted 50$ \n')

        print('The current cash amount: ',Total_amount,'$\n')
        Select_Signal = input('Please Enter the drink you want: 00water:20$, 01blacktea:30$, 10coke:40$, 11juice:50$\n 0Inserting more Coins. \n ')
        if Purchase_Signal == 0:
            if Select_Signal == '00':
                price = w_price
                sel = 1
                Drink = 'water'
            elif Select_Signal == '01':
                price = b_price
                sel = 1
                Drink = 'black tea'
            elif Select_Signal == '10':
                price = c_price
                sel = 1
                Drink = 'coke'
            elif Select_Signal == '11':
                price = j_price
                sel = 1
                Drink = 'juice'
            else:
                if Select_Signal == '0': #Inserting Coins
                    sel = 0
                else:
                    Select_Signal = Select_Signal_reg
                    sel = 1
                
        
        while sel == 1:
            print('The Drink you selected is: \n',Drink,'with the price of',price,'\n')
            confirmation = input('Are you confirmed?(Y/N):')
            if confirmation == 'Y':
                if Total_amount >= price:
                    sel = 2
                    Total_amount = Total_amount - price
                else:
                    print('Insufficient Cash')
                    sel = 2
            elif confirmation == 'N':
                CONFIRMATION_SIGNAL = 1
                sel = 2
            else:
                print('Error input:')

    #Decreasing money state

    #Giving back money state:
    time.sleep(1)
    print('Remaining Cash:',Total_amount,'$\n')
    time.sleep(1)
    print('Ready to dispose coins:\n')
    while Change_Signal == 0:
        if  Drop_Signal < Total_amount:
            Total_amount = Total_amount - 10
            time.sleep(1)
            print('Recieved 10$ \n')
            print('Cash_amount:',Total_amount,'\n')
        else:
            Drop_Signal = 0
            Change_Signal = 1
    #Reset the signal
    sel = 0
    sel_Signal_reg = Select_Signal
    Change_Signal = 0


