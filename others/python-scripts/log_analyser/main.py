from collections import Counter

# counter = Counter()

# try:
#     with open('./app.logs', 'r') as f:
#         lines = f.readlines()
#         for line in lines:
#             if "info" in line.lower():
#                 counter['info'] += 1
#             elif "error" in line.lower():
#                 counter["error"] += 1
#             elif "warning" in line.lower():
#                 counter['warning'] += 1
# except Exception as e:
#     print(f"error happened as {e}")

# try:
#     with open('./log_summary', 'w') as f:
#         for key, value in counter.items():
#             f.write(f"{key}: {value}\n")
# except Exception as e:
#     print(e)

# print(counter)
class Log_analyser:
    def __init__(self):
        self.count = Counter()
        self.fileName = None

    def _get_logs(self, fileName):
        try:
            with open(fileName, 'r') as f:
                lines = f.readlines()
                for line in lines:
                    if "info" in line.lower():
                        self.count['info'] += 1
                    elif "error" in line.lower():
                        self.count["error"] += 1
                    elif "warning" in line.lower():
                        self.count['warning'] += 1
        except Exception as e:
            print(f"error happened as {e}")

    def _get_summary(self):
        try:
            with open('./log_summary', 'w') as f:
                for key, value in self.count.items():
                    f.write(f"{key}: {value}\n")
        except Exception as e:
            print(e)

    def return_summary(self):
        self._get_logs(self.fileName)
        self._get_summary()
        return self.count


if __name__=='__main__':
    log_analyser = Log_analyser()
    log_analyser.fileName = './app.log'
    print(log_analyser.return_summary())