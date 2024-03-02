// components/MSD_plot.js
import React from 'react';
import Plot from 'react-plotly.js';

const MSD_plot = ({ tau, MSD }) => {
  return (
    <Plot
      data={[
        {
          x: tau,
          y: MSD,
          type: 'scatter',
          mode: 'lines+points',
          marker: { color: 'green' },
          name: 'MSD vs tau'
        }
      ]}
      layout={{
        width: 800,
        height: 500,
        title: 'Mean Squared Displacement',
        xaxis: { title: 'tau', type: 'log' },
        yaxis: { title: 'MSD', type: 'log' }
      }}
    />
  );
};

export default MSD_plot;
