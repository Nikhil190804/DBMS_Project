const express = require("express");
const path = require("path");
const mysql = require("mysql");
const bodyParser = require("body-parser");

const app = express();
const PORT = 3000;

const mydb = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "password",
});

mydb.connect();
mydb.query("use nnv;");

app.use(express.static(path.join(__dirname, "public")));
app.use(bodyParser.json());

app.get("*", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "index.html"));
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

app.post("/login", (req, res) => {
  const name = req.body.name;
  const password = req.body.password;
  flag = false;
  mydb.query("select * from Admin ", (err, data) => {
    if (err) {
      console.log("Error has Occureed during the Database Connection!!!!!!");
    } else {
      for (let i = 0; i < data.length; i++) {
        const row = data[i];
        console.log(row.username, row.password);
        console.log(name, password);
        if (row.username === name && row.password === password) {
          console.log("valid h ");
          res.status(200).json({ success: true, message: "Login successful" });
          flag = true;
          break;
        }
      }
      if (flag === false) {
        console.log("invalid h");
        res
          .status(401)
          .json({ success: false, message: "Invalid credentials" });
      }
    }
  });
  console.log("helo");
});

app.post("/admin-option1", (req, res) => {
  mydb.query("select * from Customer ", (err, data) => {
    if (err) {
      console.log("Error has Occureed during the Database Connection!!!!!!");
    } else {
      let json_data = JSON.stringify(data);
      res.status(200).send(json_data);
    }
  });
  console.log("admin 1 done");
});

app.post("/admin-option2", (req, res) => {
  mydb.query("select * from Delivery_Agent ", (err, data) => {
    if (err) {
      console.log("Error has Occureed during the Database Connection!!!!!!");
    } else {
      let json_data = JSON.stringify(data);
      res.status(200).send(json_data);
    }
  });
  console.log("admin 2 done");
});

app.post("/sign-up-customer", (req, res) => {
  const email = req.body.email;
  const password = req.body.password;
  const first_name = req.body.first_name;
  const middle_name = req.body.middle_name;
  const last_name = req.body.last_name;
  const date_of_birth = req.body.date_of_birth;
  const age = parseInt(req.body.age);
  const house_number =parseInt( req.body.house_number);
  const street_name = req.body.street_name;
  const city = req.body.city;
  const pincode = parseInt(req.body.pincode);
  const state = req.body.state;
  flag = false;
  let userID=null;
  mydb.query("select * from customer ", (err, data) => {
    if (err) {
      console.log("Error has Occureed during the Database Connection!!!!!!");
    } else {
      for (let i = 0; i < data.length; i++) {
        const row = data[i];
        if (row.email_ID === email && row.password === password) {
          console.log("already hh ");
          res.status(401).json({ success: false, message: "Already Exists" });
          flag = true;
          break;
        }
      }
      if (flag === false) {
        userID=data[data.length-1].userID;
        console.log("valid h");
        const sqlQuery = "INSERT INTO CUSTOMER VALUES (1, ?, ?,?,?,?,?,?,?,?,?,?,?,?,?)";
        const values = [userID+1,password,first_name,middle_name,last_name,email,userID+1,date_of_birth,age,house_number,street_name,city,pincode,state];
        mydb.query(sqlQuery,values,(err,result)=>{
          if(err){
            console.log(err);
            res.status(401).json({ success: false, message: "Already Exists" });
          }
          else{
            console.log("done insertion");
            res.status(200).json({ success: false, message: "New h" });
          }
        });
      }
    }
  });
  console.log("customer sign up done");
});
