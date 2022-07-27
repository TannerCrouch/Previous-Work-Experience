courses_url = 'url'
courses_request = requests.get(url=courses_url, headers=headers)
courses_json = json.loads(courses_request.text)
courses_responses=list()
i=1
while courses_json['data']['has_more_data']== True:
    courses_url = f'url?page={i}'
    courses_request = requests.get(url=courses_url, headers=headers)
    courses_json = json.loads(courses_request.text)
    courses_json_data = courses_json['data']['items']
    courses_responses.append(courses_json_data)
    i+=1
