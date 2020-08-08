import React from 'react';
import './App.css';
import {BrowserRouter, Route, Switch} from 'react-router-dom'
import Header from './containers/Header'
import PostingsContainer from './containers/PostingsContainer'
import Applied from './containers/Applied'
import Locations from './containers/Locations'
import Keywords from './containers/Keywords'

function App() {
  return (
    <BrowserRouter>
      <Header/>
      <Switch>
        <Route exact path="/" render={(routerProps) => <PostingsContainer {...routerProps} /> }/>
        <Route exact path="/applied" render={(routerProps) => <Applied {...routerProps} /> }/>
        <Route exact path="/locations" render={(routerProps) => <Locations {...routerProps} /> }/>
        <Route exact path="/keywords" render={(routerProps) => <Keywords {...routerProps} /> }/>
      </Switch>
  </BrowserRouter>
  );
}

export default App;
