import * as React from "react";
import { Chart } from 'react-google-charts';

class DrawChart extends React.Component<any, any> {
  render() {
    return (
      <div className={'my-pretty-chart-container'}>
        <Chart
          chartType="AreaChart"
          data={[["Year","Sales","Expenses"],["2013",1000,400],["2014",1170,460],["2015",660,1120],["2016",1030,540]]}
          options={{}}
          graph_id="AreaChart"
          width="100%"
          height="400px"
        />
      </div>
    );
  }
}

export default DrawChart
