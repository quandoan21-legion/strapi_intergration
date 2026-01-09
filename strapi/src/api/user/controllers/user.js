'use strict';

const { createCoreController } = require('@strapi/strapi').factories;
const { yup } = require('@strapi/utils');

const createUserSchema = yup
  .object({
    name: yup.string().trim().required('name is required'),
    email: yup
      .string()
      .trim()
      .email('email must be a valid email')
      .required('email is required'),
    has_entrance_exam: yup.boolean().optional(),
    is_active: yup.boolean().optional(),
    is_verified: yup.boolean().optional(),
  })
  .noUnknown(true, 'unknown field');

module.exports = createCoreController('api::user.user', ({ strapi }) => ({
  async create(ctx) {
    const body = ctx.request.body || {};
    const input = body && typeof body === 'object' && body.data ? body.data : body;

    let data;
    try {
      data = await createUserSchema.validate(input, {
        abortEarly: false,
        stripUnknown: true,
      });
    } catch (error) {
      const details = (error.inner || []).map((detail) => ({
        field: detail.path,
        message: detail.message,
      }));

      ctx.status = 400;
      ctx.body = {
        error: {
          message: 'Validation failed',
          details:
            details.length > 0
              ? details
              : [{ field: error.path, message: error.message }],
        },
      };
      return;
    }

    const existing = await strapi.db.query('api::user.user').findOne({
      where: { email: data.email },
      select: ['id'],
    });

    if (existing) {
      ctx.status = 400;
      ctx.body = {
        error: {
          message: 'email already exists',
          details: [{ field: 'email', message: 'email already exists' }],
        },
      };
      return;
    }

    const now = new Date().toISOString();
    const payload = {
      ...data,
      edit_at: now,
      create_by: now,
      edit_by: now,
    };

    const entity = await strapi.entityService.create('api::user.user', {
      data: payload,
    });

    ctx.status = 201;
    ctx.body = {
      id: entity.id,
      name: entity.name,
      email: entity.email,
      has_entrance_exam: entity.has_entrance_exam,
      is_active: entity.is_active,
      is_verified: entity.is_verified,
      edit_at: entity.edit_at,
      create_by: entity.create_by,
      edit_by: entity.edit_by,
    };
  },
}));
