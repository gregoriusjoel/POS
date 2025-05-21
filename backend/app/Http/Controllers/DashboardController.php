<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Menu;
use App\Models\Transaksi;

class DashboardController extends Controller
{
    public function summary()
    {
        $totalMenu = Menu::count();
        $totalTransaksi = Transaksi::count();
        $totalPendapatan = Transaksi::sum('total');

        return response()->json([
            'total_menu' => $totalMenu,
            'total_transaksi' => $totalTransaksi,
            'total_pendapatan' => $totalPendapatan,
        ]);
    }
}
