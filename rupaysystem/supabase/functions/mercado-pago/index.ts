import "@supabase/functions-js/edge-runtime.d.ts";

Deno.serve(async (req) => {
  try {
    const accessToken = Deno.env.get("MERCADO_PAGO_ACCESS_TOKEN");

    console.log(
      "TOKEN:",
      accessToken?.substring(0, 20)
    );

    if (!accessToken) {
      return new Response(
        JSON.stringify({ error: "Token não encontrado." }),
        {
          status: 500,
          headers: { "Content-Type": "application/json" },
        },
      );
    }

    const {
      transaction_amount,
      description,
      payer_email,
    } = await req.json();

    const response = await fetch(
      "https://api.mercadopago.com/v1/payments",
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${accessToken}`,
          "Content-Type": "application/json",
          "X-Idempotency-Key": crypto.randomUUID(),
        },
        body: JSON.stringify({
          transaction_amount,
          description,
          payment_method_id: "pix",
          payer: {
            email: payer_email,
          },
        }),
      },
    );

    const json = await response.json();

    return new Response(
      JSON.stringify({
        statusHttp: response.status,
        retorno: json,
      }),
      {
        headers: {
          "Content-Type": "application/json",
        },
      },
    );
  } catch (e) {
    return new Response(
      JSON.stringify({
        erro: String(e),
      }),
      {
        status: 500,
        headers: {
          "Content-Type": "application/json",
        },
      },
    );
  }
});