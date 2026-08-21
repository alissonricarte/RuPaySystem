import { serve } from "https://deno.land/std/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

serve(async (req) => {
  try {
    const body = await req.json();

    console.log("Webhook recebido:");
    console.log(body);

    // Ignora eventos diferentes de pagamento
    if (body.type !== "payment") {
      return new Response(
        JSON.stringify({
          message: "Evento ignorado"
        }),
        { status: 200 }
      );
    }

    const paymentId = body.data.id;

    const accessToken = Deno.env.get("MERCADO_PAGO_ACCESS_TOKEN");

    if (!accessToken) {
      return new Response(
        JSON.stringify({
          error: "Access Token não configurado."
        }),
        { status: 500 }
      );
    }

    // Consulta o pagamento no Mercado Pago
    const response = await fetch(
      `https://api.mercadopago.com/v1/payments/${paymentId}`,
      {
        headers: {
          Authorization: `Bearer ${accessToken}`
        }
      }
    );

    const payment = await response.json();

    console.log(payment);

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    if (payment.status === "approved") {
      await supabase
        .from("payments")
        .update({
          status: "pago"
        })
        .eq(
          "mercado_pago_id",
          payment.id.toString()
        );

      console.log("Pagamento atualizado.");
    }

    return new Response(
      JSON.stringify({
        received: true
      }),
      {
        status: 200
      }
    );

  } catch (error) {
    console.log(error);

    return new Response(
      JSON.stringify({
        error: error.message
      }),
      {
        status: 500
      }
    );
  }
});