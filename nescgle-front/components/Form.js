// components/Form.js
import React from 'react';

const Form = ({ parameters, handleChange, handleSubmit, downloadData }) => {
  return (
    <form onSubmit={handleSubmit}>
      <label>
        Phi:
        <input
          type="number"
          name="phi"
          value={parameters.phi}
          onChange={handleChange}
        />
      </label>
      <br />
      <label>
        kStart:
        <input
          type="number"
          name="kStart"
          value={parameters.kStart}
          onChange={handleChange}
        />
      </label>
      <br />
      <label>
        kEnd:
        <input
          type="number"
          name="kEnd"
          value={parameters.kEnd}
          onChange={handleChange}
        />
      </label>
      <br />
      <label>
        VW:
        <input
          type="checkbox"
          name="VW"
          checked={parameters.VW}
          onChange={handleChange}
        />
      </label>
      <br />
      <button type="submit">Calculate</button>
      <button onClick={downloadData}>Download Data</button>
    </form>
  );
};

export default Form;
