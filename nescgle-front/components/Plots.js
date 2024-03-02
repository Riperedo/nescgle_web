// components/Plot.js
import React from 'react';
import Plot from 'react-plotly.js';

const PlotComponent = ({ k, S }) => {
  return (
    <Plot
      data={[
        {
          x: k,
          y: S,
          type: 'scatter',
          mode: 'lines+points',
          marker: { color: 'blue' },
          name: 'Static structure factor'
        }
      ]}
      layout={{
        width: 800,
        height: 500,
        title: 'Static Structure Factor',
        xaxis: { title: 'k' },
        yaxis: { title: 'S' }
      }}
    />
  );
};

export default PlotComponent;
