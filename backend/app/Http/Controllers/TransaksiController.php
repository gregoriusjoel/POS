<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Transaksi;
use App\Models\Menu;
use App\Models\DetailTransaksi;
use Illuminate\Support\Facades\DB;

class TransaksiController extends Controller
{
    public function index()
    {
        $menus = Menu::all();
        return response()->json($menus);
    }

    public function store(Request $request)
    {
        $request->validate([
            'user_id' => 'required|exists:users,id',
            'items' => 'required|array',
            'items.*.menu_id' => 'required|exists:menus,id',
            'items.*.quantity' => 'required|integer|min:1',
        ]);

        $total_price = 0;
        DB::beginTransaction();
        try {
            $transaksi = Transaksi::create([
                'user_id' => $request->user_id,
                'total_price' => 0,
            ]);

            foreach ($request->items as $item) {
                $menu = \App\Models\Menu::find($item['menu_id']);
                $price = $menu->price * $item['quantity'];
                DetailTransaksi::create([
                    'transaksi_id' => $transaksi->id,
                    'menu_id' => $item['menu_id'],
                    'quantity' => $item['quantity'],
                    'price' => $menu->price,
                ]);
                $total_price += $price;
            }

            $transaksi->total_price = $total_price;
            $transaksi->save();

            DB::commit();
            return response($transaksi->load('details.menu'), 201);

        } catch (\Exception $e) {
            DB::rollback();
            return response(['message' => 'Gagal menyimpan transaksi', 'error' => $e->getMessage()], 500);
        }
    }

    public function show($id)
    {
        $transaksi = Transaksi::with('details.menu')->findOrFail($id);
        return response($transaksi);
    }
    public function getByUser($userId)
    {
        $transaksis = Transaksi::where('user_id', $userId)->get();
        return response($transaksis);
    }

}
