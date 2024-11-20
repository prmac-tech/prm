import {Request, Response} from 'express';

export const indexController = (req: Request, res: Response) => {
  res.render('index', {
    headerText: 'PRM UI',
    titleText: 'Home page',
  });
};
