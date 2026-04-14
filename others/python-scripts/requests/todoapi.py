import requests


requestUrl = 'https://jsonplaceholder.typicode.com/todos/100'
response = requests.get(requestUrl)
for key, value in response.json().items():
    if key == 'userId':
        if value in [1, 100, 200, 300, 5]:
            print("userFound", value)
        else:
            print("no user")
