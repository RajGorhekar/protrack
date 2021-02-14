import React, { useState } from 'react';
import NotificationAlert from 'react-notification-alert';
import {
  Alert,
  Button,
  Card,
  CardHeader,
  CardBody,
  FormGroup,
  Form,
  Input,
  CardTitle,
  Row,
  Col,
} from 'reactstrap';

function Notifications() {
  const [task, setTask] = useState([]);
  const [taskName, setTaskName] = useState('');
  const [hours, setHours] = useState(0);
  const notificationAlertRef = React.useRef(null);
  return (
    <div className='content'>
      <div className='react-notification-alert-container'>
        <NotificationAlert ref={notificationAlertRef} />
      </div>
      <Row>
        <Col md='6'>
          <Card>
            <CardHeader>
              <CardTitle tag='h4'>Task Manager</CardTitle>
            </CardHeader>
            <CardBody style={{ marginLeft: '10px' }}>
              <Form
                onSubmit={(e) => {
                  e.preventDefault();
                  setTask([...task, { data: taskName, hours: hours }]);
                  console.log(task);
                }}
              >
                <FormGroup>
                  <label>Task Description</label>
                  <Input
                    id='task-name'
                    value={taskName}
                    onChange={(e) => setTaskName(e.target.value)}
                    type='text'
                  />
                </FormGroup>
                <FormGroup>
                  <label>Estimated Time</label>
                  <Input
                    id='task-hours'
                    value={hours}
                    onChange={(e) => setHours(e.target.value)}
                    type='text'
                  />
                </FormGroup>
                <br />
                <Button className='btn-fill' color='primary' type='submit'>
                  Enter Task
                </Button>
              </Form>
            </CardBody>
          </Card>
        </Col>
        <Col md='6'>
          <Card>
            <CardHeader>
              <CardTitle tag='h4'>Task Timeline</CardTitle>
            </CardHeader>
            <CardBody>
              {task.map((t, i) => (
                <Alert color='primary' key={i}>
                  Task Name : <span>{t.data}</span>
                  <br></br>
                  Hours : <span>{t.hours}</span>
                </Alert>
              ))}
            </CardBody>
          </Card>
        </Col>
      </Row>
    </div>
  );
}

export default Notifications;
