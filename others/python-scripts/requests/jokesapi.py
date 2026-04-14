import requests 
import os

pj_joke_url =  "https://official-joke-api.appspot.com/random_joke"
dad_joke = "https://icanhazdadjoke.com/"


def get_joke_mood(url_type, mood):
    headers = {
        "Accept": "application/json"
    }

    joke = requests.get(url=url_type, headers=headers)
    if mood == 'dad':
        final_joke = joke.json()['joke']
    else:
        final_joke = joke.json()['setup'] + " " + joke.json()['punchline']
    return final_joke


mood = str(input("which joke do you want? eg dad or pj: ")).lower()

if mood == 'dad':
    url_type = dad_joke
elif mood == 'pj':
    url_type = pj_joke_url
else:
    print("invalid input")
    exit()

final_joke = get_joke_mood(url_type, mood)
print(final_joke)