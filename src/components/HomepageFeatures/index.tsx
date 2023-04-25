import React from 'react';
import clsx from 'clsx';
import styles from './styles.module.css';

type FeatureItem = {
  title: string;
  Svg: React.ComponentType<React.ComponentProps<'svg'>>;
  description: JSX.Element;
  className?: string;
};

const FeatureList: FeatureItem[] = [
  {
    title: 'Rust',
    Svg: require('@site/static/img/rust-svgrepo-com.svg').default,
    description: (
      <>
        See <code><a href="https://github.com/paritytech/polkadot">Node Implementation by Parity</a></code>
        &nbsp;and&nbsp;
        <code><a href="https://github.com/smol-dot/smoldot">smoldot</a></code>
      </>
    ),
  },
  {
    title: 'Go',
    Svg: require('@site/static/img/go-svgrepo-com.svg').default,
    description: (
      <>
        See <code><a href="https://github.com/ChainSafe/gossamer">Gossamer by Chainsafe</a></code>
      </>
    ),
  },
  {
    title: 'C++',
    Svg: require('@site/static/img/plus_logo_c_icon_214621.svg').default,
    description: (
      <>
        See <code><a href="https://github.com/soramitsu/kagome">Kagome by Soramitsu</a></code>
      </>
    ),
    className: styles.kagome,
  },
];

function Feature({title, Svg, description, className}: FeatureItem) {
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center">
      <div className='fillWhite'>
        <Svg className={styles.featureSvg + `${className ? " " + className : ""}`} role="img" />
      </div>
      </div>
      <div className="text--center padding-horiz--md">
        <h3>{title}</h3>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures(): JSX.Element {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
