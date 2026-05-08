import boto3

class ListIAMUsers:
    def __init__(self):
      self.client = boto3.client('iam')
      self.users= []

    def _get_users(self):
        response = self.client.list_users()
        for user in response['Users']:
            self.users.append(user['UserName'])
        return self.users
    
    def _get_polices(self):
        response = self.client.list_policies()
        for policy in response['Policies']:
            self.users.append(policy['PolicyName'])
        return self.users
    
    def _list_user_attached_policies(self):
       response = self.client.list_user_policies(UserName='akwasi-lomi')
       for policy in response['PolicyNames']:
           self.users.append(policy)
       return self.users
    def _get_users_policy_attached(self):
        users = self._get_users()
        for user in users:
            print(user)
            response = self.client.list_attached_user_policies(UserName=user)
            for policy in response['AttachedPolicies']:
                self.users.append(policy['PolicyName'])
        return self.users
    def call_function(self):
        return self._get_users_policy_attached()


if __name__ == "__main__":
    iam = ListIAMUsers()
    print(iam.call_function())