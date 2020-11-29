class Vote:

    def __init__(self, header):
        self.options = header['options']
        self.voters = header['voters']
        self.missing = header['missing']
        self.complete = header['complete']

    def toJson(self):
        return {
            "options": self.options,
            "voters": self.voters,
            "missing": self.missing,
            "complete": self.complete,
        }
