// An endpoint to test the application health
export async function GET() {
  return new Response(
    JSON.stringify({
      status: '200',
      statusText: 'OK'
    })
  )
}
