const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { exec } = require('child_process');
const { stdout } = require('process');
const fs = require('fs');
const path = require('path');


const app = express();


//middleware
app.use(cors());
app.use(bodyParser.json());
app.use(express.urlencoded({ extended: true }));

const port = 5000;

app.get('/', (req,res) => {
    res.send('The server is running!')
})

// Call for Hard Spheres
app.post('/EqHS', (req, res) => {
    const { phi } = req.body;

    console.log("Received request with data:", req.body);

    //VALIDATION

    const command = `julia scripts/Eq_HS_script.jl ${phi}`;

    let dir_name = `SCGLE/HS/phi${phi.toString().replace(/\./g, 'p')}/output.json`;

    const filePath = path.join(__dirname, dir_name);

    exec(command, (error, stdout, stderr) => {
        if (error) {
            console.error(`exec error: ${error}`);
            return res.status(500).send('Error executing Julia script.');
        }
        const fileData = fs.readFileSync(filePath, 'utf8');
        res.json({ message: stdout, fileData });
    });
});

app.post('/calculate', (req, res) => {
    const { phi, kStart, kEnd, VW } = req.body;

    console.log("Received request with data:", req.body);
    
    //VALIDATION

    const command = `julia ./run_nescgle.jl ${phi} ${kStart} ${kEnd} ${VW}`;


    const filePath = path.join(__dirname, 'sdk.json');

    exec(command, (error, stdout, stderr) => {
        if (error) {
            console.error(`exec error: ${error}`);
            return res.status(500).send('Error executing Julia script.');
        }
        const fileData = fs.readFileSync(filePath, 'utf8');
        res.json({ message: stdout, fileData });

    });


});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`)
})
