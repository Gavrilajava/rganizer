import React, {useState, useEffect} from 'react'
import {API_ROOT} from '../constants/api'


const Stats = props => {

  const [stats, setStats] = useState({})

  useEffect(() => {
    fetch(API_ROOT + "/stats")
      .then(resp => resp.json())
      .then(json => setStats(json))
  }, [])

  return (
    stats.postings ?
      <ol>
          <li>Postings applied: {stats.postings.applied}</li><br></br>
          <li>Companies applied: {stats.postings.companies}</li><br></br>
          <li>Unrelevant Postings: {stats.postings.unrelevant}</li><br></br>
          <li>New Postings: {stats.postings.new}</li><br></br>
          <li>Expired: {stats.postings.expired}</li><br></br>
          <li>Parsings:</li>
          <ul>
            {Object.entries(stats.parsing).map(key => <li>{key[0] + ': ' + key[1]}</li>)}
          </ul>
      </ol>
    : null
  )

}

export default Stats