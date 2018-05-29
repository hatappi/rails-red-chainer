import * as React from "react";
import { Chart } from 'react-google-charts';

interface Props {
  data: any;
}

class DrawChart extends React.Component<Props, any> {
  constructor(props: Props) {
    super(props);
  }

  render() {
    return (
      <div className={'my-pretty-chart-container'}>
        <Chart
          chartType="AreaChart"
          data={this.props.data}
          options={{ legend: 'none', hAxis: { gridlines: { count: (this.props.data.length - 2) / 3 } } }}
          width="100%"
          height="400px"
        />
      </div>
    );
  }
}

export default DrawChart
