import { Response, Request } from "express";
import pool from "../db/db";
import {
  AddCategoryBody,
  DeleteCategoryParams,
} from "../interfaces/CategoryTypes";

const getAllCategories = async (req: Request, res: Response) => {
  try {
    const getCategories = await pool.query(`SELECT * FROM CATEGORIES`);
    res.json(getCategories.rows);
  } catch (error) {
    if (error instanceof Error) {
      console.error(error.message);
      res
        .status(400)
        .json({ status: "error", msg: "error getting all categories" });
    } else {
      console.error("An unexpected error occurred:", error);
    }
  }
};

const addNewCategory = async (
  req: Request<{}, {}, AddCategoryBody>,
  res: Response
) => {
  try {
    const addCategory = `INSERT INTO CATEGORIES id VALUES $1`;
    const values = [req.body.id];
    await pool.query(addCategory, values);
    res.json({ status: "ok", msg: "Category added" });
  } catch (error) {
    if (error instanceof Error) {
      console.error(error.message);
      res.status(400).json({ status: "error", msg: "Error adding category" });
    } else {
      console.error("An unexpected error occurred:", error);
    }
  }
};

const delCatagoryById = async (
  req: Request<DeleteCategoryParams, {}, {}>,
  res: Response
) => {
    try {
        await pool.query(`DELETE FROM CATEGORIES WHERE id = $1`, [req.params.id])
        res.json({ status: "ok", msg: "Category deleted" });
    } catch (error) {
        if (error instanceof Error) {
            console.error(error.message);
            res.status(400).json({ status: "error", msg: "Error deleting category" });
          } else {
            console.error("An unexpected error occurred:", error);
          }
    }
};

export default { getAllCategories, addNewCategory, delCatagoryById };
