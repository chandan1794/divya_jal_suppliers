from . import app
from flask import render_template


@app.route('/')
def index():
    cards = [
        {
            "func": "View",
            "title": "View All Pending Orders",
            "content": "To see all the pending orders which needs to be " +
                       "completed TODAY."
        },
        {
            "func": "View",
            "title": "View All Pending Collections",
            "content": "To see all the pending collections which needs to " +
                       "be collected"
        },
        {
            "func": "Add",
            "title": "Add a New Customer",
            "content": "To add a new customer. " +
                       "Please enter all the details for future use. " +
                       "Make sure to confirm before adding."
        },
        {
            "func": "View/Edit",
            "title": "View All Customer",
            "content": "To view all the details of the customers added. " +
                       "Also you can select and edit an existing customer's details."
        },
        {
            "func": "Edit",
            "title": "Edit a Customer",
            "content": "To edit an existing customer's details."
        },
        {
            "func": "Add",
            "title": "Add a Need",
            "content": "To add need of an existing customer. A need is what customer "
                       "wants? How many kettles? How frequently? On which days? etc."
        },
        {
            "func": "View/Edit",
            "title": "View All Needs",
            "content": "To view all the details of the needs added. " +
                       "Also you can select and edit an existing need's details."
        },
        {
            "func": "Edit",
            "title": "Edit a Need",
            "content": "To edit an existing customer's details."
        }
    ]
    return render_template('index.html', cards=cards)
