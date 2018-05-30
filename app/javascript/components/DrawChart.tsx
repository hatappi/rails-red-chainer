import * as React from "react";
import { Line } from 'react-chartjs';

interface Props {
  data: any;
  labels: any;
  series: any;
  color: string,
}

class DrawChart extends React.Component<Props, any> {
  constructor(props: Props) {
    super(props);
  }

  render() {
    var data = {
	labels: this.props.labels,
	datasets: [
		{
                        fillColor: this.props.color,
			data: this.props.data,
		}
	],
    };
    return (
      <div className={'my-pretty-chart-container'}>
        <Line data={data} options={{ datasetFill: true, pointDot: true }} width="600" height="250"/>
      </div>
    );
  }
}

export default DrawChart
