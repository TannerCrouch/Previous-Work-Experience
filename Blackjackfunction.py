from pyparsing import And
import requests
import json
def game_over():
    print('Game Over!')
def BlackJack():
    money = 100
    DeckCount = 3
    shuffle = requests.get(f'https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count={DeckCount}')
    shuffle.data = shuffle.text
    shuffle_json = json.loads(shuffle.data)
    Deck_ID = shuffle_json['deck_id']
    KeepPlaying = True
    while KeepPlaying:
        DrawUrl = f'https://deckofcardsapi.com/api/deck/{Deck_ID}/draw/?count=2'
        Draw = requests.get(DrawUrl, params= {'value': 'suit'})
        Draw.data = Draw.text
        Draw_json = json.loads(Draw.data)
        Card = Draw_json["cards"]
        CardValue1 = Card[0]['value']
        CardValue2 = Card[1]['value']
        DealerDrawUrl = f'https://deckofcardsapi.com/api/deck/{Deck_ID}/draw/?count=2'
        DealerDraw = requests.get(DealerDrawUrl, params= {'value': 'suit'})
        DealerDraw.data = DealerDraw.text
        DealerDraw_json = json.loads(DealerDraw.data)
        DealerCard = DealerDraw_json["cards"]
        DealerCardValue1 = DealerCard[0]['value']
        DealerCardValue2 = DealerCard[1]['value']
        CardDictionary = {
        '1':1,
        '2':2,
        '3':3,
        '4':4,
        '5':5,
        '6':6,
        '7':7,
        '8':8,
        '9':9,
        '10':10,
        'JACK':10,
        'QUEEN':10,
        'KING':10,
        'ACE': 11
        }
        PlayerCardSum = CardDictionary.get(CardValue1)+ CardDictionary.get(CardValue2)
        DealerCardSum =CardDictionary.get(DealerCardValue1)+ CardDictionary.get(DealerCardValue2)
        print(f'You have {money} in Gold')
        bet = input("How much would you like to bet?")
        bet = int(bet)
        while bet > money:
            print('Invalid Bet')
            bet = input("Please enter a valid Bet")
            bet=int(bet)
        money -= bet
        print(f'Player Cards: {CardValue1}, {CardValue2}')
        print(f'Dealer Up Card: {DealerCardValue1}')
        while PlayerCardSum < 21:
            choice = input(" H for Hit or S for Stand: ")
            if choice.upper() == 'H':

                NewDrawUrl = f'https://deckofcardsapi.com/api/deck/{Deck_ID}/draw/?count=1'
                NewDraw = requests.get(NewDrawUrl, params= {'value': 'suit'})
                NewDraw.data = NewDraw.text
                NewDraw_json = json.loads(NewDraw.data)
                NewCard = NewDraw_json["cards"]
                NewCardValue1 = NewCard[0]['value']
                NewCardValue1 = CardDictionary.get(NewCardValue1)
                PlayerCardSum += NewCardValue1
                c=0
                while PlayerCardSum > 21 and c<1:
                    if NewCardValue1==11 or CardValue1=='ACE' or CardValue2=='ACE':
                        PlayerCardSum -= 10
                        c+=1
                    else:
                        PlayerCardSum=PlayerCardSum
                        c+=1
                print(f'New Card: {NewCardValue1}')
                print(f'Player Score: {PlayerCardSum}')

        
        
            if choice.upper() == 'S':
                print(f'Player Score: {PlayerCardSum}')
                break
    
        if PlayerCardSum == 21:
            print('BLACKJACK!')
    
    
        if PlayerCardSum > 21:
            print("YOU BUSTED!")

        print(f'Dealer Cards: {DealerCardValue1}, {DealerCardValue2}')
        while DealerCardSum < 17:
    

            print('Dealer Decides to Hit....')

            NewDrawUrl = f'https://deckofcardsapi.com/api/deck/{Deck_ID}/draw/?count=1'
            NewDraw = requests.get(NewDrawUrl, params= {'value': 'suit'})
            NewDraw.data = NewDraw.text
            NewDraw_json = json.loads(NewDraw.data)
            NewCard = NewDraw_json["cards"]
            NewCardValue1 = NewCard[0]['value']
            NewCardValue1 = CardDictionary.get(NewCardValue1)
            DealerCardSum = DealerCardSum + NewCardValue1
            print(NewCardValue1)
            c=0
            while DealerCardSum > 21 and c<1:
                if NewCardValue1==11 or DealerCardValue1=='ACE' or DealerCardValue2=='ACE':
                    DealerCardSum -= 10
                    c+=1
            
                else:
                    DealerCardSum=DealerCardSum
                    c+=1
            
            

        print("Player Score = ", PlayerCardSum)
        print("Dealer Score= ", DealerCardSum)

        if PlayerCardSum >21:
            print('You Bust, you lose!')
        elif DealerCardSum > 21:
            print("DEALER BUSTS. YOU WIN!!!")
            money += 2*bet
       
    

        if DealerCardSum == 21:
            print("DEALER HAS BLACKJACK. YOU LOSE!")
    

        if DealerCardSum == PlayerCardSum:
            print('TIE GAME')
            money += bet

        elif PlayerCardSum > DealerCardSum and PlayerCardSum <22:
            print("YOU WIN!!")
            money += 2*bet

        elif DealerCardSum > PlayerCardSum and DealerCardSum < 22 and PlayerCardSum <22:
            print("DEALER WINS!!!")
        if money <1:
            print("You're out of gold")
            game_over()
            KeepPlaying = False
            

        else:
            print(f'You now have {money} in Gold')
            Ask = input(f'Do you want to continue? (Y)es or (N)o: ')
            if Ask == 'Y' or Ask == 'y':
                KeepPlaying=True
            elif Ask == 'N' or Ask=='n':
                print(f"You're leaving with {money} in Gold. Good Bye")
                game_over()
                KeepPlaying=False
            else:
                print('invalid input, you will now continue playing anyway, hahaha')

    
 


        
                
            

BlackJack()

  

    