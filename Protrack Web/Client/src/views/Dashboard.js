import React from 'react';
import classNames from 'classnames';
import { Line, Bar } from 'react-chartjs-2';

import {
  Button,
  ButtonGroup,
  Card,
  CardHeader,
  CardBody,
  CardTitle,
  Row,
  Col,
} from 'reactstrap';

import {
  chartExample1,
  chartExample2,
  chartExample3,
  chartExample4,
} from 'variables/charts.js';

function Dashboard(props) {
  const [bigChartData, setbigChartData] = React.useState('data1');
  const setBgChartData = (name) => {
    setbigChartData(name);
  };
  return (
    <>
      <div className='content'>
        <Row>
          <Col xs='12'>
            <Card className='card-chart'>
              <CardHeader>
                <Row>
                  <Col className='text-left' sm='6'>
                    <CardTitle tag='h2'>Performance</CardTitle>
                  </Col>
                  <Col sm='6'></Col>
                </Row>
              </CardHeader>
              <CardBody>
                <div className='chart-area'>
                  <Line
                    data={chartExample1[bigChartData]}
                    options={chartExample1.options}
                  />
                </div>
              </CardBody>
            </Card>
          </Col>
        </Row>
        <Row>
          <Col lg='4'>
            <Card className='card-chart'>
              <CardHeader>
                <h5 className='card-category'>Total Shipments</h5>
                <CardTitle tag='h3'>
                  <i className='tim-icons icon-bell-55 text-info' /> 763,215
                </CardTitle>
              </CardHeader>
              <CardBody>
                <div className='chart-area'>
                  <Line
                    data={chartExample2.data}
                    options={chartExample2.options}
                  />
                </div>
              </CardBody>
            </Card>
          </Col>
          <Col lg='4'>
            <Card className='card-chart'>
              <CardHeader>
                <h5 className='card-category'>Daily Sales</h5>
                <CardTitle tag='h3'>
                  <i className='tim-icons icon-delivery-fast text-primary' />{' '}
                  3,500€
                </CardTitle>
              </CardHeader>
              <CardBody>
                <div className='chart-area'>
                  <Bar
                    data={chartExample3.data}
                    options={chartExample3.options}
                  />
                </div>
              </CardBody>
            </Card>
          </Col>
          <Col lg='4'>
            <Card className='card-chart'>
              <CardHeader>
                <h5 className='card-category'>Completed Tasks</h5>
                <CardTitle tag='h3'>
                  <i className='tim-icons icon-send text-success' /> 12,100K
                </CardTitle>
              </CardHeader>
              <CardBody>
                <div className='chart-area'>
                  <Line
                    data={chartExample4.data}
                    options={chartExample4.options}
                  />
                </div>
              </CardBody>
            </Card>
          </Col>
        </Row>
      </div>
    </>
  );
}

export default Dashboard;
