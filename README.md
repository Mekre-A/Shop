# **Introduction**
This exam is designed to test your existing flutter skills and your ability to learn and adapt to new challenges. Please read the following instructions throughly before proceeding to implementation.  
You are expected to be familiar with working in the following areas

-   Implementing network requests using **http** package

-   Working with sqlite database using **sqflite** or an ORM of your choice (using **Floor** [https://pub.dev/packages/floor] or **Moor**[https://pub.dev/packages/moor] is recommended)
    
-   Using **Platform Channels** to communicate with native android activities/services
    
-   Handling state management using the **Provider** package, (**MultiProvider**, **ChangeNotifierProvider** & **FutureProvider** )


# **What you will make**

You will be implementing a portion of a shopping app. You will consume a web API to fetch a product list and a categories list. You will implement a page which will display the lists of products which will be displayed in separate tabs according to their categories. The app will also have a shopping cart which the user can select products to add to before checkout.

# **Tasks**

 - Fork the starter project from this repository
 - Create a splash screen page  and a homepage


    # **Splash screen tasks**
    
 - Fetch a list of categories from [the web API route](#get-categories) and store this list
       of categories in an Sqlite database
 - Fetch a list of products for each category from [the web API route](#get-categoriescategory_id) and save these lists
       in the database

 - Once these are done redirect the user to the homepage

	# **Homepage tasks**  


-   The homepage should display the lists of products in tabs (in their respective categories)

-   This list of products should be displayed in a grid or alist. 

-   Each product list item in the grid should have: **an image, a name, a price and a button to add the item to the shopping cart**

-   When an item is clicked it should show the **product image, name, price, description and a button to add the item to the shopping cart** in a **SimpleDialog**  
    **(Note: 👆 this step is a Bonus)**

    # **Shopping cart tasks**


-   Design a shopping cart dialog to show items added to the shopping cart along with their quantities. 

-   Each item in this list shoud also have a **+** and a **-** button to increment or decrement the quantity.
-   The dialog should also show the *total price* of the items in the cart and a checkout button

-   When the checkout button is clicked send a post request containing the contents of the shopping cart to [the route provided here](#post-carts).

-   Add a **FloatingActionButton** (or an **IconButton** on the Appbar) in the homepage which, when clicked, displays the shopping cart dialog that u have made

-   Finally show a native android notification to the user once the user clicks checkout **(using a method channel)** with a notification title of **“Checkout successful!”**


# **API Endpoints**
 **The API root url is https://finbittesting.pythonanywhere.com**
 
  # *[GET]*  **/categories**

**This route is for fetching a list of all categories**

**Example response:**

    [
		{
			“id”:1,
			“name”: “Electronics”
		},
		{
			“id”:2,
			“name”: “Food”,
		}
	]


 # *[GET]* **/categories/<category_id>**
**This route is for fetching all products in a category, you will pass the <category_id> as a route parameter as shown above**	

**Example response:**

    {
        "id": 1,
        "name": "Electronics",
        "products": [
            {
                "id": 3,
                "name": "MacBook Pro 16\" 2020",
                "description": "16\" MacBook Pro with touch bar",
                "price": 60000.0,
                "category": 1,
             "image_url": "https://finbittesting.pythonanywhere.com/media/mbp16.png"
            },
            {
                "id": 1,
                "name": "Asus Zenbook pro",
                "description": "Brand new (sealed)",
                "price": 25000.0,
                "category": 1,
                "image_url": "https://finbittesting.pythonanywhere.com/media/asus.jpg"
            },
        ]
    }



 # *[POST]* **/carts**
 **This route is for checkout. You are required to pass the ids of all selected items in the cart along with their quantity in the following format.**

    {
        "name": “656ecfa5-c123-4b95-ae77-5706ffb14289”,
        "orders": [
           {
                "product":"1",
                "quantity":2
            },
            {
                "product":"2",
                "quantity":4
            }
        ]
    }
**Note that the *“name”* field has to be a unique string so use uuid v4 to generate one.**

# **Additional(Bonus) task suggestions**
- When a product is clicked on from the list display its details (image, name, price and description) on a new Details page instead of just a simple dialog. The page should also have the add to cart button. You can also implement a simple hero animation using the **Hero** widget to make a smooth transtition.
- Handling offline mode. Since the data will be cached in the local database u can display the data and let the user know that they are offline. You can also use a **CachedNetworkImage** to show cached product images.
- Handling the UIs responsiveness by testing it on different device sizes and optimizing the UI using media queries



# **Good luck!**