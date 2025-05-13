<<<<<<< HEAD
# README

# **Rails Application Setup Guide**

This guide will help you set up and run the Rails application on your local machine.

---

## **Prerequisites**

Before setting up the project, ensure you have the following installed:

- **Ruby**: `>= 3.2.8`
- **Bundler**: `>= 2.5.23`
- **PostgreSQL**: `>= 9.3`
- **Node.js**: `>= 18.x`
- **npm**: Comes with Node.js
- **Git`

---

## **1. Clone the Repository**

Clone the repository to your local machine:
=======
[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/DBaAVOQl)
>>>>>>> heroku/main

```bash
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name
```

<<<<<<< HEAD
---

## **2. Install Dependencies**

### **Ruby Gems**
Install the required Ruby gems using Bundler:

```bash
bundle install
```

### **Node.js Packages**
If your app uses Node.js dependencies (e.g., Bootstrap), install them using npm:

```bash
npm install
```

---

## **3. Set Up the Database**

### Before you continue:
Ensure that your POSTSQL is running and working by running this command

`sudo systemctl status postgresql` or `sudo service postgresql start`

### **Create and Migrate the Database**
Run the following commands to set up the database:

```bash
rails db:create
rails db:migrate
```

### **Seed the Database (Optional)**
If your app includes seed data, run:

```bash
rails db:schema:load
rails db:seed
```

---

## **4. Precompile Assets**

If you are running the app in production mode locally, precompile the assets:

```bash
rails assets:precompile
```

---

## **5. Start the Server**

Start the Rails server:

```bash
rails server
```

Visit the app in your browser at [http://localhost:3000](http://localhost:3000).

---

---

## **6. Deployment to Heroku**

### **Step 1: Login to Heroku**
```bash
heroku login
```

### **Step 2: Create a Heroku App**

Make sure you are in photo-quiz/myapp before you do git init
```bash
git init
git branch -m master main
git checkout -b main
git remote add heroku https://git.heroku.com/photoquiz.git
```

### **Step 4: Push to Heroku**
Push the code to Heroku:

```bash
git add .
git commit -m "message"
git push heroku main
```

### **Step 5: Run Database Migrations**
Run the database migrations on Heroku:

```bash
heroku run rails db:migrate
```
run below if updated seed.db
```bash
heroku run rails db:seed
```

### **Step 6: Open the App**
Open the app in your browser:

```bash
heroku open
```

---

## **9. Additional Notes**

### **Common Directories Ignored by Git**
The following directories are ignored by default (see `.gitignore`):

- `/log/`: Log files
- `/tmp/`: Temporary files
- `/node_modules/`: Node.js dependencies
- `/vendor/bundle/`: Bundled gems

### **Cleaning Temporary Files**
You can clean temporary files and logs using:

```bash
rails tmp:clear
rails log:clear
```

---

## **10. Troubleshooting**

### **Database Connection Issues**
Ensure PostgreSQL is running and the `DATABASE_URL` environment variable is correctly set.

### **Asset Precompilation Errors**
If you encounter asset-related errors, try running:

```bash
rails assets:clobber
rails assets:precompile
```

### **Heroku Deployment Issues**
Check the Heroku logs for errors:

```bash
heroku logs --tail
```

---

Feel free to customize this guide further based on your app's specific requirements!
=======
## Minimum Viable Product (MVP)
* Allow user to input students' names and photos
* List all the students in their specified course

## Features
### Student Card
* Full Name (First Last)
* Photo

### Quiz/Assessment
* Photo shown with multiple choices of names
* **Benefit**: Allows user to also learn other students name even if that photo doesn't belong to the student

### Flashcard 
* Go through student name and picture flashcard
* Mark as learnt or unlearnt, go thorugh flashcards
* Option to learn first name, or full name

### Future Features:
* Fill in the Blank
* Matching
* Feature to add glasses or not using llm 
* Take picture to save names and pictures automatically

## Resources:
* [Figma Design ](https://www.figma.com/design/3pKGqlUHoGMVZaht0CENrw/397_photo_quiz?node-id=0-1&t=V6bWKGZVVu7EHnBC-1)

### App link:
Heroku Link: https://photoquiz-3b8e3c177329.herokuapp.com/
>>>>>>> heroku/main
