import React from 'react';
import DefaultAdmonitionTypes from '@theme-original/Admonition/Types';

function DefinitionAdmonition(props) {
  return (
    <div className='alert alert--definition'>
      <h5 style={{color: 'blue', fontSize: 30}}>{props.title}</h5>
      <div>{props.children}</div>
    </div>
  );
}

function IndexAdmonition(props) {
  return (
    <div className='index'>{props.children}</div>
  );
}

const AdmonitionTypes = {
  ...DefaultAdmonitionTypes,
  'definition': DefinitionAdmonition,
  'algorithm': DefinitionAdmonition,
  'index': IndexAdmonition,
};

export default AdmonitionTypes;