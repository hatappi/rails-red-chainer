import * as React from "react";
import { Chart } from 'react-google-charts';

interface Props {
  data: any;
  series: any;
}

class DrawChart extends React.Component<Props, any> {
  constructor(props: Props) {
    super(props);
  }

  render() {
    let gridlines = (this.props.data.length - 2) / 3
    if (gridlines <= 0) {
      gridlines = 1
    }
    return (
      <div className={'my-pretty-chart-container'}>
        <Chart
          chartType="AreaChart"
          data={this.props.data}
          options={{
            legend: 'none',
            hAxis: {
              minValue: 1,
              gridlines: {
                count: 1
              }
            },
            series: this.props.series
          }}
          width="100%"
          height="400px"
        />
      </div>
    );
  }
}

export default DrawChart
