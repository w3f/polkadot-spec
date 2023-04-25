import React from 'react';
import DefaultAdmonitionTypes from '@theme-original/Admonition/Types';

function DefinitionAdmonition(props) {
  return (
    <div className='alert alert--definition'>
      <h5>{props.title}</h5>
      <div>{props.children}</div>
    </div>
  );
}

function AlgorithmAdmonition(props) {
  return (
    <div className='alert alert--algorithm'>
      <h5>{props.title}</h5>
      <div>{props.children}</div>
    </div>
  );
}

const AdmonitionTypes = {
  ...DefaultAdmonitionTypes,
  'definition': DefinitionAdmonition,
  'algorithm': AlgorithmAdmonition,
};

export default AdmonitionTypes;