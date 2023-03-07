###########
### WIP ###
###########

import json


def get_users(api_key, app_key):
    """
    Get users for a single DD org, using api/app keys, includes id, email, status, org id, and role id
    """
    configuration = Configuration()
    configuration.api_key["apiKeyAuth"] = api_key
    configuration.api_key["appKeyAuth"] = app_key

    data = []
    with ApiClient(configuration) as api_client:
        api_instance = UsersApi(api_client)
        response = api_instance.list_users(page_size=5000)

        for u in response.data:
            ###### HERE
            data.append(json.load(u))

    ###### HERE
    return json.dumps(data)
