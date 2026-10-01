"""ข้อมูลหนึ่งรายการในบัญชีรายรับรายจ่าย"""


class Transaction:
    def __init__(self, entry_type, category, description, amount, date):
        self.type = entry_type
        self.category = category
        self.description = description
        self.amount = amount
        self.date = date

    def to_dict(self):
        return {
            "type": self.type,
            "category": self.category,
            "description": self.description,
            "amount": self.amount,
            "date": self.date,
        }
