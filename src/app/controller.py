from . import app
from flask import render_template


@app.route('/')
def index():
    cards = [
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
        }
    ]
    return render_template('index.html', cards=cards)
