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

```bash
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name
```

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
