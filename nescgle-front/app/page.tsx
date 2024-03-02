"use client";

import React, { useState } from 'react';
import Form from '@/components/Form';
import Plot from '@/components/Plots';
import MSD_plot from '@/components/MSD_plot'

const Home = () => {
  const [parameters, setParameters] = useState({
    phi: 0.5,
    kStart: 0.0,
    kEnd: 15.0,
    VW: true
  });
  const [result, setResult] = useState(null);

  const handleChange = (e : any) => {
    const { name, value, type, checked } = e.target;
    setParameters(prevParams => ({
      ...prevParams,
      [name]: type === 'checkbox' ? checked : value
    }));
  };

  const handleSubmit = async (e : any) => {
    e.preventDefault();
    try {
      const response = await fetch('http://localhost:5000/calculate', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: `phi=${parameters.phi}&kStart=${parameters.kStart}&kEnd=${parameters.kEnd}&VW=${parameters.VW}`
      });
      const data = await response.json();
      setResult(data);
    } catch (error) {
      console.error('Error fetching data:', error);
    }
  };

  const downloadData = () => {
    if (result && result.fileData) {
      const { k, S, tau, sISF, ISF, Dzeta, Deta, D, MSD} = JSON.parse(result.fileData);
      const dataContent = k.map((kValue, index) => `${kValue}\t${S[index]}`).join('\n');
      const blob = new Blob([dataContent], { type: 'text/plain' });
      const url = URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = url;
      link.setAttribute('download', 'structure.dat');
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    }
  };

  return (
    <div>
      <h1>SCGLE version 0.0.1</h1>
      <Form
        parameters={parameters}
        handleChange={handleChange}
        handleSubmit={handleSubmit}
        downloadData={downloadData}
      />
      {result && result.fileData && (
        <div>
          <h2>Result:</h2>
          <div>
            <Plot k={JSON.parse(result.fileData).k} S={JSON.parse(result.fileData).S} />
          </div>
          <div>
            <h3>MSD vs tau</h3>
            <MSD_plot tau={JSON.parse(result.fileData).tau} MSD={JSON.parse(result.fileData).MSD} />
          </div>
        </div>
      )}
    </div>
  );
};

export default Home;
