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

const AdmonitionTypes = {
  ...DefaultAdmonitionTypes,

  // Add all your custom admonition types here...
  // You can also override the default ones if you want
  'definition': DefinitionAdmonition,
  'algorithm': DefinitionAdmonition,
};

export default AdmonitionTypes;