import React, { useState } from 'react';
import PropTypes from 'prop-types';
import { Button, Panel, PanelMain, PanelMainBody } from '@patternfly/react-core';

import OutputLine from './OutputLine';
import './Terminal.scss';

const Terminal = ({ linesets }) => {
  let currentColor = 'default';
  
  const colorMap = new Proxy({
    '31': 'red',
    '32': 'lightgreen',
    '33': 'orange',
    '34': 'deepskyblue',
    '35': 'mediumpurple',
    '36': 'cyan',
    '37': 'grey',
    '91': 'red',
    '92': 'lightgreen',
    '93': 'yellow',
    '94': 'lightblue',
    '95': 'violet',
    '96': 'turquoise',
    '0': 'default',
  }, {
    get: (target, name) => {
      if (name)
        return (target.hasOwnProperty(name) ? target[name] : 'default');
      else
        return this._currentColor;
    }
  });

  const scrollToBottom = () => {
    window.scrollTo({
      top: document.documentElement.scrollHeight,
      behavior: 'smooth',
    });
  }

  const scrollToTop = () => {
    window.scrollTo({
      top: 0,
      behavior: 'smooth',
    });
  }

  const lines = () => {
    return linesets.flatMap(lineset => (
      lineset.output.replace(/\r\n/,"\n").replace(/\n$/,'').split("\n").map(line => (
        { output_type: lineset.output_type, output: line, timestamp: lineset.timestamp }
      ))
    ));
  }

  const colorize = (line) => {
    const pattern = /(?:\033\[(?:.*?)(?<color>\d+)m)?(?<text>[^\033]+)/g;

    return (Array.from(line.matchAll(pattern), match => {
      currentColor = colorMap[match.groups.color];
      return (<span style={`color: ${currentColor}`}>{match.groups.text}</span>);
    }));
  }

  return (
    <Panel isScrollable className="terminal">
      <PanelMain>
        <PanelMainBody>
          <Button variant="link" className="pull-right scroll-link-bottom" onClick={scrollToBottom}>
            {__('Scroll to bottom')}
          </Button>
          <div className="printable">
            {lines.map((line, index) => (
              <OutputLine key={index} index={index} timestamp={line.timestamp} type={line.output_type}>
                {colorize(line)}
              </OutputLine>
            ))}
          </div>
          <Button variant="link" className="pull-right scroll-link-top" onClick={scrollToTop}>
            {__('Scroll to top')}
          </Button>
        </PanelMainBody>
      </PanelMain>
    </Panel>
  );
};

Terminal.propTypes = {
  linesets: PropTypes.array(PropTypes.shape({
    output_type: PropTypes.string.isRequired,
    output: PropTypes.string.isRequired,
    timestamp: PropTypes.number.isRequired,
  })),
};

Terminal.defaultProps = {
  linesets: [],
};

export default Terminal;
