import React from 'react';
import './App.css';
import {BrowserRouter, Route, Switch} from 'react-router-dom'
import Header from './containers/Header'
import PostingsContainer from './containers/PostingsContainer'
import Applied from './containers/Applied'

function App() {
  return (
    <BrowserRouter>
      <Header/>
      <Switch>
        <Route exact path="/" render={(routerProps) => <PostingsContainer {...routerProps} /> }/>
        <Route exact path="/applied" render={(routerProps) => <Applied {...routerProps} /> }/>
      </Switch>
  </BrowserRouter>
  );
}

export default App;
